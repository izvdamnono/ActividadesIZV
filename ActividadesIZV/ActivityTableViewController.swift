//
//  ActivityTableViewController.swift
//  ActividadesIZV
//
//  Created by Fernando on 28/01/2017.
//  Copyright © 2017 Fernando. All rights reserved.
//

import UIKit

class ActivityTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, UITextFieldDelegate,
    UIImagePickerControllerDelegate, UINavigationControllerDelegate,
    SendResponse {

    //MARK: Outlets
    @IBOutlet weak var tfTitulo: UITextField!
    @IBOutlet weak var tfResumen: UITextField!
    @IBOutlet weak var tvDescripcion: UITextView!
    
    @IBOutlet weak var lbDepartamento: UILabel!
    @IBOutlet weak var lbProfesor: UILabel!
    @IBOutlet weak var lbGrupo: UILabel!
    
    @IBOutlet weak var lbFecha: UILabel!
    @IBOutlet weak var lbInicio: UILabel!
    @IBOutlet weak var lbFin: UILabel!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var ivActividad: UIImageView!
    
    var changeImage   = false
    
    //MARK: Pickers
    var viewPicker    = UIPickerView()
    var datePicker    = UIDatePicker()
    
    //MARK: Informacion acerca de la Actividad
    var teachers      = [] as [Profesor]
    var groups        = [] as [Grupo]
    var departs       = [] as [Departamento]
    var row           = 0
    
    //MARK: Objeto Api que nos permite mostrar la informacion
    var api           = Api()
    let queue         = DispatchQueue(label:"addAct", attributes: .concurrent)
    
    
    //MARK: Actividad
    var actividad: Actividad?
    
    //MARK: Variables que almacenan el id del profesor, departamento y grupo de la actividad
    var profesor     = Profesor()
    var departamento = Departamento()
    var grupo        = Grupo()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //Reconocedores de gestos que nos permiten detectar la pulsacion de cada label de nuestra tabla
         let tapDep = UITapGestureRecognizer(target: self, action: #selector(ActivityTableViewController.tapDep))
         let tapPro = UITapGestureRecognizer(target: self, action: #selector(ActivityTableViewController.tapPro))
         let tapGrp = UITapGestureRecognizer(target: self, action: #selector(ActivityTableViewController.tapGrp))
         let tapFec = UITapGestureRecognizer(target: self, action: #selector(ActivityTableViewController.tapFec))
         let tapIni = UITapGestureRecognizer(target: self, action: #selector(ActivityTableViewController.tapIni))
         let tapFin = UITapGestureRecognizer(target: self, action: #selector(ActivityTableViewController.tapFin))
         let tapImg = UITapGestureRecognizer(target: self, action: #selector(ActivityTableViewController.tapImg))
        
         //Agregamos los reconocedores de gestos a cada label
         lbDepartamento.addGestureRecognizer(tapDep)
         lbProfesor.addGestureRecognizer(tapPro)
         lbGrupo.addGestureRecognizer(tapGrp)
         lbFecha.addGestureRecognizer(tapFec)
         lbInicio.addGestureRecognizer(tapIni)
         lbFin.addGestureRecognizer(tapFin)
         ivActividad.addGestureRecognizer(tapImg)
        
         viewPicker.delegate     = self
         viewPicker.dataSource   = self
         
         tfTitulo.delegate       = self
         tfResumen.delegate      = self
         tvDescripcion.delegate  = self
        
         //Le damos borde al textview
         tvDescripcion.layer.borderColor = tfTitulo.layer.borderColor
         tvDescripcion.layer.borderWidth = 1.0
         
         //Caracteristicas del datepicker
         datePicker.timeZone     = NSTimeZone.local
         datePicker.minimumDate  = Date()
         datePicker.date         = Date()
         
         //inicializamos los datos
         queue.async{
         
            self.api.connectToServer(path:"departamento/", method:"GET", protocolo: self)
            self.api.connectToServer(path:"profesor/", method:"GET", protocolo: self)
            self.api.connectToServer(path:"grupo/", method:"GET", protocolo: self)
         }
        
        //Cargamos los datos si los tiene
        if let act = actividad {
            
            navigationItem.title = act.titulo
            
            if !act.imagen.isEmpty {
                
                let urlStr  = api.getPathAssets() + act.imagen
                if let data = NSData(contentsOf: URL(string:urlStr)!){
                    
                    ivActividad.image = UIImage(data:data as Data)
                }
            }
            
            tfTitulo.text       = act.titulo
            tfResumen.text      = act.resumen
            tvDescripcion.text  = act.descripcion
            lbDepartamento.text = act.profesor.departamento.nombre
            lbProfesor.text     = act.profesor.nombre
            lbGrupo.text        = act.grupo.nombre
            lbFecha.text        = act.fecha
            lbInicio.text       = act.horaInicio
            lbFin.text          = act.horaFin
            
            //Inicializamos los elementos seleccionados
            departamento = act.profesor.departamento
            profesor     = act.profesor
            grupo        = act.grupo
            
        }
        
        //Deshabilitamos el boton
        saveButton.isEnabled = updateSaveButtonState()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        let isPresenting = presentingViewController is UINavigationController
        
        if isPresenting {
            
            dismiss(animated: true, completion: {})
        }
        else if let owningNavigation = navigationController {
            
            owningNavigation.popViewController(animated: true)
        }
        else {
            fatalError("ActivityController no esta dentro de la navegacion")
        }
    }
     
     // MARK: - Table view data source
     
     /*override func numberOfSections(in tableView: UITableView) -> Int {
     // #warning Incomplete implementation, return the number of sections
     
     return 1
     }
     
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     // #warning Incomplete implementation, return the number of rows
     return 9
     }
     */
     /*override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
     let cell = tableView.dequeueReusableCell(withIdentifier: "cellTeacher", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     
     
     
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
     
     /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
     
     /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
     
     /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
     
     /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
     
     //MARK: Reconocedores utilizados para obtener respuesta al pulsar sobre un label
     func tapDep(sender:UITapGestureRecognizer) {
     
        viewPicker.tag = 0
     
        //Mostramos el dialogo
        showViewPickerDialog()
     }
     
     func tapPro(sender:UITapGestureRecognizer) {
     
        viewPicker.tag = 1
     
        //Mostramos el dialogo
        showViewPickerDialog()
     }
     
     func tapGrp(sender:UITapGestureRecognizer) {
     
        viewPicker.tag = 2
     
        //Mostramos el dialogo
        showViewPickerDialog()
     }
     
     func tapFec(sender:UITapGestureRecognizer) {
     
        datePicker.tag = 0
     
        //Mostramos el dialogo
        datePicker.datePickerMode = .date
        showDatePickerDialog()
     }
     
     func tapIni(sender:UITapGestureRecognizer) {
     
        datePicker.tag = 1
     
        //Mostramos el dialogo
        datePicker.datePickerMode = .time
        showDatePickerDialog()
     }
     
     func tapFin(sender:UITapGestureRecognizer) {
     
        datePicker.tag = 2
     
        //Mostramos el dialogo
        datePicker.datePickerMode = .time
        showDatePickerDialog()
     }
    
    func tapImg(sender:UITapGestureRecognizer) {
        
        hideKeyboard()
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType    = .photoLibrary
        imagePickerController.delegate      = self
        present(imagePickerController, animated:true, completion:{})
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    
        dismiss(animated:true, completion:{})
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            
            return
        }
        
        ivActividad.image = selectedImage
        changeImage       = true
        
        dismiss(animated:true, completion:{})
    }
    
    
     //Metodo utilizado para mostrar un dialogo cuyo elemento principal es un viewpicker
     func showViewPickerDialog() {
     
        //Ocultamos el teclado
        hideKeyboard()
        
        let alertController = UIAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
     
        //Le damos un tamaño y una posicion especifica
        let margin: CGFloat = 10.0
     
        viewPicker.bounds.size.width  = alertController.view.bounds.size.width - margin * 4.0
        viewPicker.bounds.size.height = 125
        viewPicker.transform = CGAffineTransform(translationX: 35, y: -25)
     
        viewPicker.reloadAllComponents()
        alertController.view.addSubview(viewPicker)
     
     
        let done = UIAlertAction(title: "Añadir", style: .default, handler: {(alert: UIAlertAction!) in self.loadTeacherInfo()})
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
     
        alertController.addAction(done)
        alertController.addAction(cancel)
     
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion:{})
        }
        
     }
     
     //Metodo que muestra un dialogo donde se selecciona una fecha u hora
     func showDatePickerDialog(){
        
        //Ocultamos el teclado
        hideKeyboard()
        
        let alertController = UIAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
     
        let margin: CGFloat = 10.0
     
        datePicker.bounds.size.width  = alertController.view.bounds.size.width - margin * 4.0
        datePicker.bounds.size.height = 125
        datePicker.transform = CGAffineTransform(translationX: 35, y: -25)
     
        alertController.view.addSubview(datePicker)
     
        let done = UIAlertAction(title: "Añadir", style: .default, handler: {(alert: UIAlertAction!) in self.loadDateOrTime()})
     
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
     
        alertController.addAction(done)
        alertController.addAction(cancel)
     
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion:{})
        }
     
     }
     
     //MARK: Delegate PickerView
     
     
     func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
     }
     
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
     
        switch pickerView.tag {
     
            case 0:
                return departs.count
            case 1:
                return teachers.count
            case 2:
                return groups.count
            default:
                return 0
        }
     }
     
     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
     
        switch pickerView.tag {
            
        case 0:
            if row >= 0, row <= departs.count - 1 {
                return departs[row].nombre
            }
            return ""
            
        case 1:
            if row >= 0, row <= teachers.count - 1 {
                return teachers[row].nombre
            }
            return ""
        case 2:
            if row >= 0, row <= groups.count - 1 {
                return groups[row].nombre
            }
            return ""
        default:
            return ""
        }
     }
    
     func loadTeacherInfo() {
     
        switch viewPicker.tag {
     
            case 0:
                //Recargamos los profesores del departamento seleccionado
                if row >= 0, row <= departs.count - 1 {
                    
                    lbDepartamento.text = departs[row].nombre
                    let path = "departamento/" + String(departs[row].id) + "/profesor"
                    
                    departamento = departs[row]
                    
                    queue.async {
                        self.api.connectToServer(path: path, method: "GET", protocolo: self)
                    }
                }
            
     
            case 1:
                
                if row >= 0, row <= teachers.count - 1 {
                    
                    lbProfesor.text = teachers[row].nombre
                    profesor        = teachers[row]
                }
     
            case 2:
                
                if row >= 0, row <= teachers.count - 1 {                    
                    
                    lbGrupo.text    = groups[row].nombre
                    grupo           = groups[row]
                }
     
            default:
                break
     
        }
     
        //Nos aseguramos que siempre se tiene que seleccionar una fila
        viewPicker.tag = 0
     
        //Comprobamos si podemos guardar
        saveButton.isEnabled = updateSaveButtonState()
     }
     
     //Cargar fecha
     func loadDateOrTime() {
     
        let dateFormatter  = DateFormatter()
        var label:UILabel? = nil
     
        switch datePicker.tag {
     
            case 0:
                dateFormatter.dateFormat = "YYYY-MM-dd"
                label = lbFecha
     
            case 1:
     
                //El formato de la k es para mostrar la hora en el formato de 24h
                dateFormatter.dateFormat = "HH:mm:ss"
                dateFormatter.locale     = NSLocale(localeIdentifier: "en_US_POSIX") as Locale

                label = lbInicio
     
        case 2:
                dateFormatter.dateFormat = "HH:mm:ss"
                dateFormatter.locale     = NSLocale(localeIdentifier: "en_US_POSIX") as Locale

                label = lbFin
     
            default: return
        }
     
        if label != nil { label!.text = dateFormatter.string(from: datePicker.date)}
        datePicker.tag = 0
     
        saveButton.isEnabled = updateSaveButtonState()
     }
     
     func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
     
        //Obtenemos la fila seleccionada de nuestro picker para obtener los datos al finalizar el dialogo
        self.row = row
     
     }
    
     //function to hide data in
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     
        textField.resignFirstResponder()
        return true
     }
     
     func textViewShouldReturn(_ textView: UITextView) -> Bool {
     
        textView.resignFirstResponder()
        return true
     }
     
     
     func textFieldDidEndEditing(_ textField: UITextField) {
     
        if textField == tfTitulo, let texto = textField.text {
     
            navigationItem.title = texto
        }
     
        saveButton.isEnabled = updateSaveButtonState()
     }
        
     //funcion con la que obtenemos los datos de de nuestro servidor
     func sendResponse(response: Any) -> Void {
     
        print(response)
        guard   let arrayR = response as? [[String:Any]],
                arrayR.count > 0
            else {
     
                return
        }
     
        let element = arrayR[0]
     
        if Profesor(json:element) != nil {
     
            //Si el primer elemento es un profesor tenemos un array de profesores
            var teacherAux = [] as [Profesor]
     
            for teacher in arrayR {
     
                let profesor = Profesor(json:teacher)!
                
                teacherAux.append(profesor)
            }
     
            teachers = teacherAux
     
        } else if Departamento(json:element) != nil{
     
            for departament in arrayR{
     
                departs.append(Departamento(json:departament)!)
            }
     
        } else if Grupo(json:element) != nil {
     
            for group in arrayR {
                
                let grupo = Grupo(json: group)!
                
                groups.append(grupo)
            }
        }
     
     }
     
     //Metodo utilizado para la comunicacion entre las distintas escenas
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
     
        guard   let button = sender as? UIBarButtonItem,
                button === saveButton else {
                    return
        }
        
        //Almacenamos los datos de la actividad
        
        var id      = 0
        var imagen  = ""
        
        if actividad != nil {
            
           id       = actividad!.id
           imagen   = actividad!.imagen
        }
        
        let tit     = tfTitulo.text!
        let res     = tfResumen.text!
        let des     = tvDescripcion.text ?? ""
        let pro     = self.profesor
        let grp     = self.grupo
        let fec     = lbFecha.text!
        let hini    = lbInicio.text!
        let hfin    = lbFin.text!
        
        
        //Comprobamos que tenga imagen 
        if changeImage {
            
            //Codificamos la imagen en base64
            let imageData:Data = UIImagePNGRepresentation(ivActividad.image!)!
            imagen = imageData.base64EncodedString()
            
        }
        
        //Insertamos la actividad en la BBDD de nuestro servidor
        actividad = Actividad(id: id, profesor: pro, grupo: grp, titulo: tit, descripcion: des, resumen:res, fecha: fec, horaInicio: hini , horaFin: hfin, imagen: imagen)
        
        /*let json  = actividad!.toJsonData()
        
        queue.async {
            
            self.api.connectToServer(path:"actividad", method:"POST", data: json)
        }*/
        
     }
     
     func updateSaveButtonState() -> Bool {
     
        //Comprobamos que la actividad tenga titulo y resumen
        if tfTitulo.text == nil || tfResumen.text == nil {return false}
     
        //Comprobamos que el profesor elegido sea del departamento seleccionado
        if grupo.id == 0 || profesor.id == 0 || departamento.id == 0 { return false }
        
        var exists = false
     
        if profesor.departamento.id == departamento.id {
            
            exists = true
        }
        /*for teacher in teachers {
     
            if teacher.id == profesor.id, teacher.departamento.id == departamento.id {
                exists = true
                break
            }
        }*/
     
        if !exists {return false}
        
        //Comprobamos que la hora inicial sea menor que la final y que la fecha se haya elegido
        let formatterH    = DateFormatter()
        let formatterF    = DateFormatter()
     
        formatterF.dateFormat = "YYYY-MM-dd"
        formatterH.dateFormat = "HH:mm:ss"
        formatterH.locale     = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        
        guard   let _ = formatterF.date(from: lbFecha.text!),
                let hini = lbInicio.text,
                let hfin = lbFin.text,
                let dateini = formatterH.date(from: hini),
                let datefin = formatterH.date(from:hfin),
                dateini < datefin  else {
     
                    return false
        }
     
        return true
     }
    
     func hideKeyboard() -> Void {
        
        if tfTitulo.isFirstResponder {
            
            tfTitulo.resignFirstResponder()
        }
        else if tfResumen.isFirstResponder {
            
            tfResumen.resignFirstResponder()
        }
        else if tvDescripcion.isFirstResponder {
            
            tvDescripcion.resignFirstResponder()
        }
     }
}
