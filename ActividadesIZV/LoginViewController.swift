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
    
    let api                 = Api()
    let queue               = DispatchQueue(label:"myFile", attributes: .concurrent)
    
    var activityIndicator   = UIActivityIndicatorView()
    var messageFrame        = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Comprobamos el token del usuario
        /*DispatchQueue.main.async {
            
            if let token = UtilsFile.getInfo() {
                
                self.api.connectToServer(path: "usuario", method: "POST", data: ["token" : token], protocolo: self)
            }
        }*/
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
        
        //Mostramos cargando
        progressBarDisplayer(msg: "Iniciando Sesion", true)
        
        //Realizamos la peticion
        let payload =  ["username": username, "password": password]
        api.connectToServer(path: "usuario", method: "POST", data: payload, protocolo: self)
        
    }
    
    func progressBarDisplayer(msg:String, _ indicator:Bool) {
        
        let strLabel        = UILabel(frame: CGRect(x:50, y:0, width:200, height: 50))
        strLabel.text       = msg
        strLabel.textColor  = UIColor.white
        
        messageFrame        = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 2, width: 200, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor    = UIColor(white: 0, alpha: 0.7)
        
        if indicator {
            
            self.activityIndicator       = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
            self.activityIndicator.frame = CGRect(x:0, y:0, width:50, height: 50)
            self.activityIndicator.startAnimating()
            messageFrame.addSubview(activityIndicator)
        }
        
        messageFrame.addSubview(strLabel)
        view.addSubview(messageFrame)
    }
    
    func sendResponse(response: Any) {
    
        
        if let server = response as? [String: Any] {
            
            if server["response"] as? String == "ok" {
                
                performSegue(withIdentifier: "loginSuccess", sender: nil)
            }
            else if server["response"] as? String == "error" {
                
                DispatchQueue.main.async {
                    
                    self.messageFrame.removeFromSuperview()
                    
                    //Error en el login
                    let actionsheet = UIAlertController(title:"Error de autenticacion", message: "Usuario o contraseña incorrectos", preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title:"Cancelar", style: .cancel){ action -> Void in
                        print("cancel")
                    }
                    
                    actionsheet.addAction(cancelAction)
                    self.present(actionsheet, animated: true, completion: nil)
                }
            }
            else if let server = response as? [String:Any]{
                
                let token = JWT.encode(server, algorithm: .hs256("izvkey".data(using: .utf8)!))
                
                DispatchQueue.main.async {
                    
                    if UtilsFile.saveInfo(data: token) {
                        
                        self.messageFrame.removeFromSuperview()
                        //Se guarda en el fichero y se inicia el segue
                        self.performSegue(withIdentifier: "loginSuccess", sender: nil)
                    }
                }
                
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
