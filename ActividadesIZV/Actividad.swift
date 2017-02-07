//
//  Actividad.swift
//  ConnectToServer
//
//  Created by Fernando on 24/01/2017.
//  Copyright © 2017 Fernando. All rights reserved.
//

import Foundation

class Actividad {
    var id: Int
    var profesor: Profesor
    var grupo: Grupo
    var titulo: String
    var descripcion: String
    var resumen: String
    var fecha: String
    var horaInicio: String
    var horaFin: String
    var imagen: String
    var lugar:[String:Double]
    
    convenience init(){
        
        self.init(id:0, profesor: Profesor(), grupo: Grupo(), titulo: "", descripcion: "", resumen:"", fecha: "", horaInicio: "", horaFin: "", imagen: "", lugar: [:])
    }
    
    init(id: Int, profesor: Profesor , grupo: Grupo , titulo: String, descripcion: String , resumen: String , fecha: String , horaInicio: String , horaFin: String, imagen: String, lugar: [String:Double]){
        self.id          = id
        self.profesor    = profesor
        self.grupo       = grupo
        self.titulo      = titulo
        self.descripcion = descripcion
        self.resumen     = resumen
        self.fecha       = fecha
        self.horaInicio  = horaInicio
        self.horaFin     = horaFin
        self.imagen      = imagen
        self.lugar       = lugar
    }
    
    //Constructor utilizado para crear una actividad a partir de un json
    init?(json: [String: Any]){
        
        guard   let id           = json["id"] as? Int,
                let dictPro      = json["idap"] as? [String:Any],
                let profesor     = Profesor(json: dictPro),
                let dictGrp      = json["idag"] as? [String:Any],
                let grupo        = Grupo(json: dictGrp),
                let titulo       = json["titulo"] as? String,
                let descripcion  = json["descripcion"] as? String,
                let resumen      = json["resumen"] as? String,
                let fecha        = json["fecha"] as? String,
                let horaInicio   = json["hini"] as? String,
                let horaFin      = json["hfin"] as? String,
                let imagen       = json["imagen"] as? String,
                let lugar        = json["lugar"] as? [String:Double]
        else
        {
            return nil
        }
        
        self.id          = id
        self.profesor    = profesor
        self.grupo       = grupo
        self.titulo      = titulo
        self.descripcion = descripcion
        self.resumen     = resumen
        self.fecha       = fecha
        self.horaInicio  = horaInicio
        self.horaFin     = horaFin
        self.imagen      = imagen
        self.lugar       = lugar
    }
    
    //Metodo utilizado para obtener un json de una actividad
    func toJsonData() -> [String: Any] {
        
        return [
            
            "id" : self.id,
            "idap" : self.profesor.id,
            "idag" : self.grupo.id,
            "titulo" : self.titulo,
            "descripcion" : self.descripcion,
            "resumen" : self.resumen,
            "fecha" : self.fecha,
            "hini" : self.horaInicio,
            "hfin" : self.horaFin,
            "imagen" : self.imagen,
            "lugar": self.lugar
        ]
    }
    
}
