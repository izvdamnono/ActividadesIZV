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
    var id: Int
    var nombre: String
    var departamento: Departamento
    
    //Inicializador para la creacion del profesor por defecto
    convenience init(){
        self.init(idProfesor: 0, nombreProfesor: "", departamento: Departamento())
    }
    
    //Constructor utilizado para la creacion de un objeto con ciertos datos
    init( idProfesor id: Int, nombreProfesor nombre: String, departamento: Departamento){
        
        self.id             = id
        self.nombre         = nombre
        self.departamento   = departamento
    }
    
    //Constructor utilizado para crear un profesor a partir de un json 
    init?(json: [String: Any]){
        
        guard   let id      = json["id"] as? Int,
                let nombre  = json["nombreProfesor"] as? String,
                let dicDep  = json["idpd"] as? [String:Any],
                let dep     = Departamento(json:dicDep)
        else
        {
            return nil
        }
        
        self.id             = id
        self.nombre         = nombre
        self.departamento   = dep
    }
    
    //Metodo utilizado para obtener un json de un profesor
    func toJsonData() -> [String: Any] {
        
        return ["id" : self.id, "nombre" : self.nombre, "idpd" : self.departamento.id]
    }
    
}


