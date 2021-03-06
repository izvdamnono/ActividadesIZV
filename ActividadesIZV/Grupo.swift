//
//  Grupo.swift
//  ConnectToServer
//
//  Created by Fernando on 24/01/2017.
//  Copyright © 2017 Fernando. All rights reserved.
//
import Foundation

class Grupo {
    
    //Por defecto tienen dichos valores
    var id:Int
    var nombre:String
    
    convenience init(){
        
        self.init(idGrupo: 0, nombreGrupo: "")
    }
    
    //Constructor utilizado para la creacion de un objeto con ciertos datos
    init( idGrupo id: Int, nombreGrupo nombre: String){
        
        self.id     = id
        self.nombre = nombre
    }
    
    //Constructor utilizado para crear un profesor a partir de un json
    init?(json: [String: Any]){
        
        guard   let id      = json["id"] as? Int,
                let nombre  = json["nombreGrupo"] as? String
            else
        {
            return nil
        }
        
        self.id     = id
        self.nombre = nombre
    }
    
    //Metodo utilizado para obtener un json de un profesor
    func toJsonData() -> [String: Any] {
        
        return ["id" : self.id, "nombreGrupo" : self.nombre]
    }
    
}
