//
//  MainTableViewController.swift
//  ActividadesIZV
//
//  Created by Fernando on 28/01/2017.
//  Copyright © 2017 Fernando. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController, SendResponse {

    //MARK: Objetos conexion
    let api     = Api()
    let queue   = DispatchQueue(label:"SelAct", attributes: .concurrent)
    
    //MARK: Actividades
    var actividades              = [] as [Actividad]
    var actividadAux: Actividad? = nil
    var modifyServer             = [:] as [String : Any]
    
    //Array donde se almacenan todas las actividades que se eliminaran
    var actividadesDelete        = [] as [Actividad]
    var rowsDelete               = [] as [Int]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        queue.async {
            
            self.api.connectToServer(path:"actividad/", method:"GET", protocolo: self)
        }
        
        /*self.tableView.rowHeight            = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight   = 125*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Actions
    
    @IBAction func sender(_ sender: UIBarButtonItem) {
        
        self.tableView.setEditing( !self.tableView.isEditing, animated: true)
        
        if actividadesDelete.count > 0 {
            
            var dict = [] as [[String:Int]]
            
            for actividad in actividadesDelete {
                
                dict.append(["id":actividad.id])
            }
            
            print(dict)
            print(rowsDelete)
            //LLamar a la api para que elimine las actividades seleccionadas
            queue.async{
                self.api.connectToServer(path: "actividad/", method: "DELETE", data: dict, protocolo: self)
            }
            
            modifyServer = ["eliminar" : 0]
        }

    }
    
    //Utilizado para habilitar la seleccion multiple sin llamar al metodo prepare
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        return !self.tableView.isEditing
    }
    
    //Metodo que se llama cuando se selecciona una celda
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        rowsDelete.append(indexPath.row)
        actividadesDelete.append(actividades[indexPath.row])
        
        
    }
    
    //Metodo utilizado cuando se deselecciona una celda
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        for index in 0..<actividadesDelete.count {
            
            if actividadesDelete[index] === actividades[indexPath.row] {
                
                actividadesDelete.remove(at:index)
                rowsDelete.remove(at:index)
                
                return
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return actividades.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let idCell  = "ActivityTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: idCell, for: indexPath) as? ActivityTableViewCell else {
            
            fatalError("Identificador erroneo o clase erronea")
        }
        
        let actividad = actividades[indexPath.row]
            
        //Cargamos los datos
        
        cell.ivActividad.image = UIImage(named:"Image")
        
        if !actividad.imagen.isEmpty {
            
            let urlStr  = api.getPathAssets() + actividad.imagen
            if let data = NSData(contentsOf: URL(string:urlStr)!){
                
                cell.ivActividad.image = UIImage(data:data as Data)
            }
        }
        
        cell.lbTitulo.text          = actividad.titulo
        cell.lbResumen.text         = actividad.resumen
        cell.lbDepartamento.text    = actividad.profesor.departamento.nombre
        cell.lbProfesor.text        = actividad.profesor.nombre
        cell.lbGrupo.text           = actividad.grupo.nombre
        cell.lbFecha.text           = actividad.fecha
        cell.lbInicio.text          = actividad.horaInicio
        cell.lbFin.text             = actividad.horaFin
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    /*override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        
    }*/
    

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
            case "AddActivity":
                print("Nueva Actividad")
            
            case "ShowActivity":
                
                guard let activityDetailController = segue.destination as? ActivityTableViewController else {
                    fatalError("Destino incorrecto")
                }
            
                guard let selectedCell = sender as? ActivityTableViewCell else {
                    
                    fatalError("Sender inesperado")
                }
            
                guard let indexPath = tableView.indexPath(for: selectedCell) else {
                    
                    fatalError("La columna seleccionada no esta en la tabla")
                }
                
                activityDetailController.actividad = actividades[indexPath.row]
            
            default: fatalError("Incorrecto identificador")
            
        }
    }
 
    
    @IBAction func unwindToActivityList(sender: UIStoryboardSegue){
        
        guard let controller = sender.source as? ActivityTableViewController, let actividad = controller.actividad else {
            
            return
        }
        
        actividadAux = actividad
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            
            //Actualizamos una actividad
            queue.async {
                
                let path = "actividad/" + String(actividad.id)
                let json = actividad.toJsonData()
                
                self.api.connectToServer(path: path, method: "PUT", data: json, protocolo: self)
            }
            
            modifyServer = ["actualizar" : selectedIndexPath]
            
        }
        else{
            
            //Añadimos una actividad
            
            queue.async {
                
                let json = actividad.toJsonData()
                self.api.connectToServer(path: "actividad", method: "POST", data: json, protocolo: self)
            }
            
            modifyServer = ["insertar": 0]
        }
    }

    func sendResponse(response:Any) -> Void {
     
        if let activities = response as? [[String:Any]] {
            
            actividades = []
            
            for actividad in activities {
                
                actividades.append(Actividad(json:actividad)!)
            }
            
            DispatchQueue.main.async{
                
                self.tableView.reloadData()
            }
        }
        else if let responseServer = response as? [String: Any] {
            
            if let codigo = responseServer["response"] as? String, codigo == "ok" {
                
                if let ins = modifyServer["insertar"] as? Int {
                    
                    let newIndexPath = IndexPath(row: actividades.count, section: 0)
                    
                    actividades.append(actividadAux!)
                    tableView.insertRows(at: [newIndexPath], with: .automatic)

                }
                else if let indexPath = modifyServer["actualizar"] as? IndexPath {
                    
                    actividades[indexPath.row] = actividadAux!
                    tableView.reloadRows(at: [indexPath], with: .none)
                }
                else if let ins = modifyServer["eliminar"] as? Int{
                    
                    /**
                     *  Se realiza de esta forma para evitar un error de fuera de rango
                     *  Este ocurria cuando se intentaba eliminar dos elementos separados
                     *  siendo uno de ellos el ultimo
                     */
                    if rowsDelete.count == actividades.count {
                        
                        actividades.removeAll()
                    }
                    else {
                        
                        //Eliminamos las filas
                        for index in 0..<rowsDelete.count {
                            
                            switch rowsDelete[index]{
                                
                                case actividades.endIndex:
                                    actividades.removeLast()
                                default:
                                    actividades.remove(at: rowsDelete[index])
                            }
                        }
                    }
                    
                    actividadesDelete = []
                    rowsDelete        = []
                    
                    DispatchQueue.main.async {
                        
                        self.tableView.reloadData()
                    }
                }
                
                actividadAux = nil
            }
        }
        
    }
    
}
