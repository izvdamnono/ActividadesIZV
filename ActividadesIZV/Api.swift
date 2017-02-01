//
//  Api.swift
//  ConnectToServer
//
//  Created by Fernando on 24/01/2017.
//  Copyright © 2017 Fernando. All rights reserved.
//

import Foundation

class Api {
    
    var scheme  = "https"
    var domain  = "iosapplication-fernan13.c9users.io"
    var api     = "api"
    
    init ( scheme : String = "", domain: String = "", api: String = "" ) {
        
        if !scheme.isEmpty { self.scheme = scheme }
        if !domain.isEmpty { self.domain = domain }
        if !api.isEmpty    { self.api    = api }
    }
    
    func getDomain() -> String {
        
        return scheme + "://" + domain
    }
    
    func getPathAssets() -> String {
        
        return self.getDomain() + "/assets/img/"
    }
    
    func connectToServer ( path: String, method: String, data: Any = [:], protocolo: SendResponse? = nil ) {
        
        //Comprobamos que la URL generada sea correcta
        
        if let url = NSURL(string: scheme + "://" + domain + "/" + api + "/" + path) {
            
            //Creamos la peticion
            let request = NSMutableURLRequest(url: url as URL)
            
            //Indicamos el tipo de metodo utilizado para conectarnos con el servidor
            request.httpMethod = method
            
            //Comprobamos si el metodo es PUT o POST para introducir correctamente el parámetro json
            switch method {
                
                case "POST", "PUT", "DELETE":
                    
                    if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted) {
                        
                        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                        request.httpBody = jsonData
                    }
                
                default: break
            }
            
            
            //Creamos la conexion
            let task = URLSession.shared.dataTask(with: request as URLRequest){
                
                (data,response,error) -> Void in
                
                if error != nil{
                    
                    print(error!.localizedDescription)
                    return
                }
                
                do {
                    
                    switch method {
                        
                        case "GET":
                        
                            if let conn = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [Any] {
                             
                                if protocolo != nil {
                                    
                                    protocolo!.sendResponse(response: conn)
                                }
                            }
                        
                        
                        default :
                            
                            if let conn = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                                
                                if protocolo != nil {
                                    
                                    protocolo!.sendResponse(response: conn)
                                }
                            }
                        
                    }
                    
                } catch let error as NSError {
                    print(error)
                }
            }
            
            task.resume()
            
        }
        
    }
    
}
