//
//  Profesor.swift
//  ConnectToServer
//
//  Created by Fernando on 24/01/2017.
//  Copyright © 2017 Fernando. All rights reserved.
//

import Foundation

class Profesor {
    
    //Por defecto tienen dichos valores
    var id      = 0
    var nombre  = ""
    var idDep   = 0
    
    //Inicializador para la creacion del profesor por defecto
    init(){
        
    }
    
    //Constructor utilizado para la creacion de un objeto con ciertos datos
    init( idProfesor id: Int, nombreProfesor nombre: String, idDepartamento idDep: Int){
        
        self.id     = id
        self.nombre = nombre
        self.idDep  = idDep
    }
    
    //Constructor utilizado para crear un profesor a partir de un json 
    init?(json: [String: Any]){
        
        guard   let id      = json["id"] as? Int,
                let nombre  = json["nombreProfesor"] as? String,
                let idDep   = json["idpd"] as? Int
        else
        {
            return nil
        }
        
        self.id     = id
        self.nombre = nombre
        self.idDep  = idDep
    }
    
    //Metodo utilizado para obtener un json de un profesor
    func toJsonData() -> [String: Any] {
        
        return ["id" : self.id, "nombre" : self.nombre, "idpd" : self.idDep]
    }
    
}


