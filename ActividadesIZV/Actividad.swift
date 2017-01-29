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
    var idProfesor: Int
    var idGrupo: Int
    var titulo: String
    var descripcion: String
    var resumen: String
    var fecha: String
    var horaInicio: String
    var horaFin: String
    var imagen: String
    
    convenience init(){
        
        self.init(id:0, idProfesor:0, idGrupo:0, titulo: "", descripcion: "", resumen:"", fecha: "", horaInicio: "", horaFin: "", imagen: "")
    }
    
    init(id: Int, idProfesor: Int , idGrupo: Int , titulo: String, descripcion: String , resumen: String , fecha: String , horaInicio: String , horaFin: String, imagen: String){
        self.id          = id
        self.idProfesor  = idProfesor
        self.idGrupo     = idGrupo
        self.titulo      = titulo
        self.descripcion = descripcion
        self.resumen     = resumen
        self.fecha       = fecha
        self.horaInicio  = horaInicio
        self.horaFin     = horaFin
        self.imagen      = imagen
    }
    
    //Constructor utilizado para crear una actividad a partir de un json
    init?(json: [String: Any]){
        
        guard   let id           = json["id"] as? Int,
                let idProfesor   = json["idap"] as? Int,
                let idGrupo      = json["idag"] as? Int,
                let titulo       = json["titulo"] as? String,
                let descripcion  = json["descripcion"] as? String,
                let resumen      = json["resumen"] as? String,
                let fecha        = json["fecha"] as? String,
                let horaInicio   = json["hini"] as? String,
                let horaFin      = json["hfin"] as? String,
                let imagen       = json["imagen"] as? String
        else
        {
            return nil
        }
        
        self.id          = id
        self.idProfesor  = idProfesor
        self.idGrupo     = idGrupo
        self.titulo      = titulo
        self.descripcion = descripcion
        self.resumen     = resumen
        self.fecha       = fecha
        self.horaInicio  = horaInicio
        self.horaFin     = horaFin
        self.imagen      = imagen
    }
    
    //Metodo utilizado para obtener un json de una actividad
    func toJsonData() -> [String: Any] {
        
        return [
            
            "id" : self.id,
            "idap" : self.idProfesor,
            "idag" : self.idGrupo,
            "titulo" : self.titulo,
            "descripcion" : self.descripcion,
            "resumen" : self.resumen,
            "fecha" : self.fecha,
            "hini" : self.horaInicio,
            "hfin" : self.horaFin,
            "imagen" : self.imagen
        ]
    }
}
