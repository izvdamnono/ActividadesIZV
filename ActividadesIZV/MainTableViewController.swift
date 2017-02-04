//
//  MainTableViewController.swift
//  ActividadesIZV
//
//  Created by Fernando on 28/01/2017.
//  Copyright © 2017 Fernando. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController, SendResponse, UISearchBarDelegate {

    //MARK: Objetos conexion
    let api     = Api()
    let queue   = DispatchQueue(label:"SelAct", attributes: .concurrent)
    
    //MARK: Actividades
    var actividades              = [] as [Actividad]
    var actividadesF:[Actividad]?
    //var actividadAux: Actividad? = nil
    //var modifyServer             = [:] as [String : Any]
    
    //Array donde se almacenan todas las actividades que se eliminaran
    var actividadesDelete        = [] as [Actividad]
    var rowsDelete               = [] as [IndexPath]
    
    //Barra de Busqueda
    var searchController         = UISearchController(searchResultsController: nil)
    var scopes                   = ["Profesor", "Fecha"]
    
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
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = scopes
        definesPresentationContext = true
        
        //Toolbar
        self.navigationController?.isToolbarHidden = false
        var items = [UIBarButtonItem]()
        let flex  = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        items.append(flex)
        items.append(UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(MainTableViewController.sender)))
        items.append(flex)
        items.append(UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(MainTableViewController.refreshData)))
        items.append(flex)
        items.append(UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(MainTableViewController.seeWebActivity)))
        items.append(flex)
        items.append(UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(MainTableViewController.searchClick)))
        items.append(flex)
        items.append(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(MainTableViewController.onAddActivity)))
        items.append(flex)
        
        self.toolbarItems = items
        self.navigationItem.rightBarButtonItem = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    
    func seeWebActivity() {
        
        performSegue(withIdentifier: "WebActivity", sender: nil)
        
    }
    
    func onAddActivity() {
        
        performSegue(withIdentifier: "AddActivity", sender: nil)
    }
    
    
    func searchClick(_ sender: UIBarButtonItem) {
        
        self.tableView.tableHeaderView = searchController.searchBar
        searchController.isActive = true
            
        DispatchQueue.main.async{
            self.searchController.becomeFirstResponder()
        }
        
    }
    
    //Metodo sobreescrito para poder tomar nosotros el control de nuestra barra de busqueda
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.tableView.tableHeaderView = nil
        searchController.isActive = false
        actividadesF = nil
        
        DispatchQueue.main.async {
            self.searchController.resignFirstResponder()
        }
        
    }
    
    
    func refreshData(_ sender: UIBarButtonItem) {
        
        queue.async{
            self.api.connectToServer(path:"actividad/", method:"GET", protocolo: self)
        }
        print()
    }
    
    func sender(_ sender: UIBarButtonItem) {
        
        self.tableView.setEditing( !self.tableView.isEditing, animated: true)
        
        if actividadesDelete.count > 0 {
            
            var dict = [] as [[String:Int]]
            
            for actividad in actividadesDelete {
                
                dict.append(["id":actividad.id])
            }
            
            //LLamar a la api para que elimine las actividades seleccionadas
            queue.async{
                self.api.connectToServer(path: "actividad/", method: "DELETE", data: dict, protocolo: self)
            }
            
        }

    }
    
    //Metodo que se llama cuando cambia el texto del campo de texto de la barra de busqueda
    func filterContentForSearchText(searchText:String, scopeIndex:Int ){
        
        
        switch scopeIndex {
            
            case 0:
                actividadesF = actividades.filter({$0.profesor.nombre.range(of: searchText, options: .caseInsensitive) != nil})
            case 1:
                actividadesF = actividades.filter({$0.fecha == searchText})
            
            default: return
        }
        
        DispatchQueue.main.async{
            
            self.tableView.reloadData()
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        if searchBar.selectedScopeButtonIndex == 1 {
            
            showDatePickerDialog()
            return false
        }
        
        return true
    }
    
    //Metodo que muestra un dialogo donde se selecciona una fecha u hora
    func showDatePickerDialog(){
        
        let datePicker              = UIDatePicker()
        datePicker.timeZone         = NSTimeZone.local
        datePicker.datePickerMode   = .date
        
        if !searchController.searchBar.text!.isEmpty && searchController.isActive {
            
            let formatter               = DateFormatter()
            formatter.dateFormat        = "YYYY-MM-dd"
            datePicker.date             = formatter.date(from:searchController.searchBar.text!)!
        }
        
        let alertController     = UIAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let margin: CGFloat = 10.0
        
        datePicker.bounds.size.width  = alertController.view.bounds.size.width - margin * 4.0
        datePicker.bounds.size.height = 125
        datePicker.transform = CGAffineTransform(translationX: 35, y: -25)
        
        alertController.view.addSubview(datePicker)
        
        let done = UIAlertAction(title: "Seleccionar", style: .default, handler: {(alert: UIAlertAction!) in self.filterContentByDate(date: datePicker.date)})
        
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
        
        alertController.addAction(done)
        alertController.addAction(cancel)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion:{})
        }
        
    }
    
    func filterContentByDate(date: Date){
        
        let formatter           = DateFormatter()
        formatter.dateFormat    = "YYYY-MM-dd"
        
        searchController.searchBar.text = formatter.string(from: date)
        self.updateSearchResults(for: searchController)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        if !searchBar.text!.isEmpty {
            
            searchBar.text = ""
        }
        
        searchBar.resignFirstResponder()
    }
    
    //Utilizado para habilitar la seleccion multiple sin llamar al metodo prepare
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        return !self.tableView.isEditing
    }
    
    //Metodo que se llama cuando se selecciona una celda
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        rowsDelete.append(indexPath)
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
        
        if searchController.isActive && !searchController.searchBar.text!.isEmpty{
            
            return actividadesF!.count
        }
        
        return actividades.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let idCell  = "ActivityTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: idCell, for: indexPath) as? ActivityTableViewCell else {
            
            fatalError("Identificador erroneo o clase erronea")
        }
        
        let actividad: Actividad
        
        if searchController.isActive && !searchController.searchBar.text!.isEmpty {
            
            actividad = actividadesF![indexPath.row]
        }
        else
        {
            actividad = actividades[indexPath.row]
        }
            
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
            
            case "WebActivity":
                print("Web")
            
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
                
                let actividad: Actividad
                
                if searchController.isActive && !searchController.searchBar.text!.isEmpty {
                    actividad = actividadesF![indexPath.row]
                }
                else {
                    
                    actividad = actividades[indexPath.row]
                }
                
            
                //self.searchBarCancelButtonClicked(searchController.searchBar)
                activityDetailController.actividad = actividad
            
            default: fatalError("Incorrecto identificador")
            
        }
    }
 
    
    @IBAction func unwindToActivityList(sender: UIStoryboardSegue){
        
        guard let controller = sender.source as? ActivityTableViewController, let actividad = controller.actividad else {
            
            return
        }
        
        //actividadAux = actividad
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            
            //Actualizamos una actividad
            queue.async {
                
                let path = "actividad/" + String(actividad.id)
                let json = actividad.toJsonData()
                
                self.api.connectToServer(path: path, method: "PUT", data: json, protocolo: self)
            }
            
        }
        else{
            
            //Añadimos una actividad
            
            queue.async {
                
                let json = actividad.toJsonData()
                self.api.connectToServer(path: "actividad", method: "POST", data: json, protocolo: self)
            }
            
        }
    }

    func sendResponse(response:Any) -> Void {
     
        if let activities = response as? [[String:Any]] {
            
            let isSearching = searchController.isActive && !searchController.searchBar.text!.isEmpty
            actividades = []
            
            for actividad in activities {
                
                actividades.append(Actividad(json:actividad)!)
            }
            
            
            if isSearching {
                
                self.updateSearchResults(for: self.searchController)
                //self.filterContentForSearchText(searchText: searchController.searchBar.text!)
            }
            else {
                
                DispatchQueue.main.async{
                    
                    self.tableView.reloadData()
                }
            }
            
        }
        else if let responseServer = response as? [String: Any] {
            
            if let codigo = responseServer["response"] as? String, codigo == "ok" {
                
                
                /*if modifyServer["insertar"] != nil {
                    
                    let newIndexPath = IndexPath(row: actividades.count, section: 0)
                    
                    actividades.append(actividadAux!)
                    //tableView.insertRows(at: [newIndexPath], with: .automatic)

                }
                else if let indexPath = modifyServer["actualizar"] as? IndexPath {
                    
                    actividades[indexPath.row] = actividadAux!
                    /*if !isSearching{
                        tableView.reloadRows(at: [indexPath], with: .none)
                    }*/
                    
                }
                else if modifyServer["eliminar"] != nil {
                    
                    /**
                     *  Se realiza de esta forma para evitar un error de fuera de rango
                     *  Este ocurria cuando se intentaba eliminar dos elementos separados
                     *  siendo uno de ellos el ultimo
                     */
                    
                    let tam = rowsDelete.count
                    for index in stride(from: tam, to: 0, by: -1){
                        
                        actividades.remove(at: rowsDelete[index-1].row)
                    }
                    
                    actividadesDelete = []
                    rowsDelete        = []
                    
                    /*DispatchQueue.main.async {
                            
                        self.tableView.reloadData()
                    }*/
                }*/
                
                
                DispatchQueue.main.async {
                    
                    self.api.connectToServer(path: "actividad/", method: "GET", protocolo: self)
                    
                }
                
                
                //actividadAux = nil
            }
        }
        
    }
    
}

extension MainTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let scope = searchController.searchBar.selectedScopeButtonIndex
        self.filterContentForSearchText(searchText: searchController.searchBar.text!, scopeIndex: scope)
    }
}
