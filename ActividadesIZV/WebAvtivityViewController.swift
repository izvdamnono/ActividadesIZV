//
//  WebAvtivityViewController.swift
//  ActividadesIZV
//
//  Created by Fernando on 04/02/2017.
//  Copyright © 2017 Fernando. All rights reserved.
//

import WebKit
import UIKit

class WebAvtivityViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    var api: Api? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        api         = Api()
        let url     = URL(string:api!.getGraphics())
        let request = URLRequest(url: url!)
    
        webView.delegate = self
        
        DispatchQueue.main.async {
            
            self.webView.loadRequest(request)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
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
