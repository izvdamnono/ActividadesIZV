//
//  LoginViewController.swift
//  ActividadesIZV
//
//  Created by Fernando on 21/02/2017.
//  Copyright © 2017 Fernando. All rights reserved.
//

import UIKit
import JWT

class LoginViewController: UIViewController, SendResponse {

    
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    let api     = Api()
    let queue   = DispatchQueue(label:"myFile", attributes: .concurrent)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Comprobamos el token del usuario
        DispatchQueue.main.async {
            
            if let token = UtilsFile.getInfo() {
                print(["token" : token])
                self.api.connectToServer(path: "usuario", method: "POST", data: ["token" : token], protocolo: self)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func login(_ sender: UIButton) {
        
        guard let username = tfUsername.text,
              let password = tfPassword.text else {
                
                return
        }
        
        //Realizamos la peticion
        let payload =  ["username": username, "password": password]
        api.connectToServer(path: "usuario", method: "POST", data: payload, protocolo: self)
        
    }
    
    func sendResponse(response: Any) {
    
        if let server = response as? [String: Any] {
            print(server)
            if server["response"] as? String == "ok" {
                
                performSegue(withIdentifier: "loginSuccess", sender: nil)
            }
            else if server["response"] as? String == "error" {
                
                //Error en el login
                print("Error")
            }
            else if let server = response as? [String:Any]{
                
                let token = JWT.encode(server, algorithm: .hs256("izvkey".data(using: .utf8)!))
                
                queue.async {
                    
                    if UtilsFile.saveInfo(data: token) {
                        
                        print("token guardado")
                    }
                }
                
                //Se guarda en el fichero y se inicia el segue
                performSegue(withIdentifier: "loginSuccess", sender: nil)
            }
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
