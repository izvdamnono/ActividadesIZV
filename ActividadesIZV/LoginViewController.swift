//
//  LoginViewController.swift
//  ActividadesIZV
//
//  Created by Fernando on 21/02/2017.
//  Copyright © 2017 Fernando. All rights reserved.
//

import UIKit
import JWT

class LoginViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let token = JWT.encode(["id": 8], algorithm: .hs256("culo".data(using: .utf8)!))
        
        print("Mierda", token)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
