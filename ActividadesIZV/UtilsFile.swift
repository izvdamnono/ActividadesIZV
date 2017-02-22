//
//  UtilsFile.swift
//  ActividadesIZV
//
//  Created by Fernando on 22/02/2017.
//  Copyright © 2017 Fernando. All rights reserved.
//

import Foundation

struct UtilsFile {
    
    static func saveInfo(data: String) -> Bool {
        
        let file   = "token.txt"
        
        if let path = getFilePath(file: file) {
            do {
                try "".write(to: path, atomically: false, encoding: String.Encoding.utf8)
                try data.write(to: path, atomically: false, encoding: String.Encoding.utf8)
                
                return true
            }
            catch { print("no se pudo guardar")}
            
        }
        
        return false
    }
    
    static func getInfo() -> String? {
        
        let file = "token.txt"
        
        if let path = getFilePath(file:file) {
            
            do {
                
                let text = try String(contentsOf: path, encoding: String.Encoding.utf8)
                
                return text
                
            }catch{print("Fallo al leer los datos")}
        }
        
        return nil
    }
    
    private static func getFilePath(file:String) -> URL? {
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let path = dir.appendingPathComponent(file)
            
            return path
        }
        
        return nil
    }
}
