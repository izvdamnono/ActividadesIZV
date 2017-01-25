//
//  ViewController.swift
//  ConnectToServer
//
//  Created by Fernando on 21/01/2017.
//  Copyright © 2017 Fernando. All rights reserved.
//


import UIKit
import Foundation

class ViewController: UIViewController, SendResponse {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let profesor    = Profesor()
        profesor.nombre = "Pepito"

        let api     = Api()
        let queue   = DispatchQueue(label: "api", attributes: .concurrent)
        
        queue.async {
            //Consulta todas las actividades
            api.connectToServer(path: "actividad", method:"GET", protocolo: self )
            
            //Insercion profesor, de la clase de profesor le enviamos su json
            //api.connectToServer(path: "profesor", method:"POST", data: profesor.toJsonData() ,protocolo:self)
            
            //Consulta profesor
            //api.connectToServer(path: "profesor", method: "GET", protocolo: self)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Metodo del protocolo utilizado para comunicar ambas clases
    func sendResponse(response: Any) -> Void {
        
        print(response)
        
        switch response {
            
            case let array as [[String : Any]]:
                //Array de Json
                print(array)
            
            case let json as [String:Any]:
                //Json normal
                print(json)
            
            default: return
        }
        
    }
    
}

