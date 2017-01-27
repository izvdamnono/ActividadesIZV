//
//  AddActivityTableViewController.swift
//  ActividadesIZV
//
//  Created by Fernando on 26/01/2017.
//  Copyright © 2017 Fernando. All rights reserved.
//

import UIKit

class AddActivityTableViewController: UITableViewController, SendResponse, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var tfProfesor: UITextField!
    @IBOutlet weak var tfDepartamento: UITextField!
    @IBOutlet weak var tfGrupo: UITextField!
    
    var viewPicker    = UIPickerView()
    
    //MARK: Informacion acerca de la Actividad
    var teachers      = [] as [Profesor]
    var groups        = [] as [Grupo]
    var departs       = [] as [Departamento]
    var flag          = -1
    
    //MARK: Objeto Api que nos permite mostrar la informacion
    var api           = Api()
    let queue         = DispatchQueue(label:"addAct", attributes: .concurrent)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tfDepartamento.inputView = viewPicker
        tfProfesor.inputView     = viewPicker
        tfGrupo.inputView        = viewPicker
        
        tfDepartamento.delegate = self
        tfProfesor.delegate     = self
        tfGrupo.delegate        = self
        
        viewPicker.delegate     = self
        viewPicker.dataSource   = self
        
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
    
    //MARK: Delegate PickerView
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        switch textField {
            
            case tfDepartamento:
                flag = 0
            case tfProfesor:
                flag = 1
            case tfGrupo:
                flag = 2
            default: flag = -1
        }
        
        viewPicker.reloadAllComponents()
        viewPicker.isHidden = false
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch flag {
            
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
        
        switch flag {
            
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
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch flag {
            
            case 0:
                //Recargamos los profesores del departamento seleccionado
                tfDepartamento.text = departs[row].nombre
                let path = "departamento/" + String(departs[row].id) + "/profesor"
                
                queue.async {
                    self.api.connectToServer(path: path, method: "GET", protocolo: self)
                }
            
            case 1:
                tfProfesor.text = teachers[row].nombre
            case 2:
                tfGrupo.text = groups[row].nombre
            default:
                break
            
        }
        
        //trying to hide the dataPicker
        self.view.endEditing(true)
        //dataPickerView.reloadAllComponents()
        //self.dataPickerView.resignFirstResponder()
        //self.dataPickerView.frameForAlignmentRect(CGRectMake(0, 900, 375, 219))
        
    }
    
    //function to hide data in
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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
    
}
