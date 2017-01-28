//
//  AddActividadTableViewController.swift
//  ActividadesIZV
//
//  Created by Fernando on 28/01/2017.
//  Copyright © 2017 Fernando. All rights reserved.
//

import UIKit

class AddActividadTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, UITextFieldDelegate, SendResponse {

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
    
    //MARK: Pickers
    var viewPicker    = UIPickerView()
    var datePicker    = UIDatePicker()
    
    //MARK: Informacion acerca de la Actividad
    var teachers      = [] as [Profesor]
    var groups        = [] as [Grupo]
    var departs       = [] as [Departamento]
    var row           = -1
    
    //MARK: Objeto Api que nos permite mostrar la informacion
    var api           = Api()
    let queue         = DispatchQueue(label:"addAct", attributes: .concurrent)
    
    
    //MARK: Variables que almacenan el id del profesor, departamento y grupo de la actividad
    var idProfesor     = 0
    var idDepartamento = 0
    var idGrupo        = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //Reconocedores de gestos que nos permiten detectar la pulsacion de cada label de nuestra tabla
        let tapDep = UITapGestureRecognizer(target: self, action: #selector(AddActividadTableViewController.tapDep))
        let tapPro = UITapGestureRecognizer(target: self, action: #selector(AddActividadTableViewController.tapPro))
        let tapGrp = UITapGestureRecognizer(target: self, action: #selector(AddActividadTableViewController.tapGrp))
        let tapFec = UITapGestureRecognizer(target: self, action: #selector(AddActividadTableViewController.tapFec))
        let tapIni = UITapGestureRecognizer(target: self, action: #selector(AddActividadTableViewController.tapIni))
        let tapFin = UITapGestureRecognizer(target: self, action: #selector(AddActividadTableViewController.tapFin))
        
        //Agregamos los reconocedores de gestos a cada label
        lbDepartamento.addGestureRecognizer(tapDep)
        lbProfesor.addGestureRecognizer(tapPro)
        lbGrupo.addGestureRecognizer(tapGrp)
        lbFecha.addGestureRecognizer(tapFec)
        lbInicio.addGestureRecognizer(tapIni)
        lbFin.addGestureRecognizer(tapFin)
        
        viewPicker.delegate     = self
        viewPicker.dataSource   = self
        
        tfTitulo.delegate       = self
        tfResumen.delegate      = self
        tvDescripcion.delegate  = self
        
        datePicker.timeZone     = NSTimeZone.local
        datePicker.minimumDate  = Date()
        
        //inicializamos los datos
        queue.async{
            
            self.api.connectToServer(path:"departamento", method:"GET", protocolo: self)
            self.api.connectToServer(path:"profesor", method:"GET", protocolo: self)
            self.api.connectToServer(path:"grupo", method:"GET", protocolo: self)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    //Metodo utilizado para mostrar un dialogo cuyo elemento principal es un viewpicker
    func showViewPickerDialog() {
        
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
            return departs[row].nombre
        case 1:
            return teachers[row].nombre
        case 2:
            return groups[row].nombre
        default:
            return ""
        }
    }
    
    func loadTeacherInfo() {
        
        guard row >= 0 else {
            return
        }
        
        switch viewPicker.tag {
            
        case 0:
            //Recargamos los profesores del departamento seleccionado
            lbDepartamento.text = departs[row].nombre
            let path = "departamento/" + String(departs[row].id) + "/profesor"
            
            idDepartamento = departs[row].id
            
            queue.async {
                self.api.connectToServer(path: path, method: "GET", protocolo: self)
            }
            
        case 1:
            lbProfesor.text = teachers[row].nombre
            idProfesor      = teachers[row].id
            
        case 2:
            lbGrupo.text    = groups[row].nombre
            idGrupo         = groups[row].id
            
        default:
            break
            
        }
        
        //Nos aseguramos que siempre se tiene que seleccionar una fila
        viewPicker.tag = 0
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
            dateFormatter.dateFormat = "k:mm:ss"
            label = lbInicio
            
        case 2:
            dateFormatter.dateFormat = "k:mm:ss"
            label = lbFin
            
        default: return
        }
        
        if label != nil { label!.text = dateFormatter.string(from: datePicker.date)}
        datePicker.tag = 0
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
    
    
    //funcion con la que obtenemos los datos de de nuestro servidor
    func sendResponse(response: Any) -> Void {
        
        guard let arrayR = response as? [[String:Any]],
            arrayR.count > 0
            else {
                
                return
            }
        
        let element = arrayR[0]
        
        if Profesor(json:element) != nil {
            
            //Si el primer elemento es un profesor tenemos un array de profesores
            var teacherAux = [] as [Profesor]
            
            for teacher in arrayR {
                
                teacherAux.append(Profesor(json:teacher)!)
            }
            
            teachers = teacherAux
            
        } else if Departamento(json:element) != nil{
            
            for departament in arrayR{
                
                departs.append(Departamento(json:departament)!)
            }
            
        } else if Grupo(json:element) != nil {
            
            for group in arrayR {
                
                groups.append(Grupo(json:group)!)
            }
        }
        
    }
    
    //Metodo utilizado para la comunicacion entre las distintas escenas
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
     super.prepare(for: segue, sender: sender)
     
     guard let button = sender as? UIBarButtonItem,
     button === saveButton else {
     return
     }
     }*/
}
