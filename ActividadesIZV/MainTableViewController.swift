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
    var actividades = [] as [Actividad]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        queue.async {
            
            self.api.connectToServer(path:"actividad", method:"GET", protocolo: self)
        }
        
        self.tableView.rowHeight            = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight   = 200
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
        if !actividad.imagen.isEmpty {
                
            let urlStr  = api.getPathAssets() + actividad.imagen
            if let data = NSData(contentsOf: URL(string:urlStr)!){
                    
                cell.ivActividad.image = UIImage(data:data as Data)
            }
        }
            /*if let catUrl = URL(string: urlStr) {
                
                //Creamos la conexion
                let session = URLSession(configuration: .default)
                let task    = session.dataTask(with: catUrl){
                    
                    (data,response,error) -> Void in
                    
                    if error != nil{
                        
                        print(error!.localizedDescription)
                        return
                    }
                    
                    if let imageData = data {
                            
                        cell.ivActividad.image = UIImage(data:imageData)
                    }
                    
                    
                }
                
                task.resume()
                /*queue.async {
                    
                    task.resume()
                }*/
            }*/
        
        cell.lbTitulo.text      = actividad.titulo
        cell.lbResumen.text     = actividad.resumen
        cell.lbProfesor.text    = String(actividad.idProfesor)
        cell.lbGrupo.text       = String(actividad.idGrupo)
        cell.lbFecha.text       = actividad.fecha
        cell.lbInicio.text      = actividad.horaInicio
        cell.lbFin.text         = actividad.horaFin
        
        return cell
    }
    

    /*
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
    
    @IBAction func unwindToActivityList(sender: UIStoryboardSegue) {
      
        
        guard let controller = sender.source as? ActivityTableViewController, let actividad = controller.actividad else {
            
            return
        }
        
        print(actividad)
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
    }
}
