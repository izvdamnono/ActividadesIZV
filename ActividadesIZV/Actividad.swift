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
    var descripcion: String
    var resumen: String
    var fecha: String
    var horaInicio: String
    var horaFin: String
    
    init(id: Int, idProfesor: Int , idGrupo: Int , descripcion: String , resumen: String , fecha: String , horaInicio: String , horaFin: String){
        self.id          = id
        self.idProfesor  = idProfesor
        self.idGrupo     = idGrupo
        self.descripcion = descripcion
        self.resumen     = resumen
        self.fecha       = fecha
        self.horaInicio  = horaInicio
        self.horaFin     = horaFin
    }
    
    //Constructor utilizado para crear una actividad a partir de un json
    init?(json: [String: Any]){
        
        guard   let id           = json["id"] as? Int,
                let idProfesor   = json["idap"] as? Int,
                let idGrupo      = json["idag"] as? Int,
                let descripcion  = json["descripcion"] as? String,
                let resumen      = json["resumen"] as? String,
                let fecha        = json["fecha"] as? String,
                let horaInicio   = json["hini"] as? String,
                let horaFin      = json["hfin"] as? String
        else
        {
            return nil
        }
        
        self.id          = id
        self.idProfesor  = idProfesor
        self.idGrupo     = idGrupo
        self.descripcion = descripcion
        self.resumen     = resumen
        self.fecha       = fecha
        self.horaInicio  = horaInicio
        self.horaFin     = horaFin

    }
    
    //Metodo utilizado para obtener un json de una actividad
    func toJsonData() -> [String: Any] {
        
        return [
            
            "id" : self.id,
            "idap" : self.idProfesor,
            "idag" : self.idGrupo,
            "descripcion" : self.descripcion,
            "resumen" : self.resumen,
            "fecha" : self.fecha,
            "hini" : self.horaInicio,
            "hfin" : self.horaFin
        ]
    }
}
