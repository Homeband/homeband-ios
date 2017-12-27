//
//  ViewController.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 16/11/17.
//  Copyright © 2017 HEH. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class ViewController: UIViewController {

    @IBOutlet weak var tfLogin: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onClickConnexion(_ sender: Any) {
        //let login: String! = tfLogin.text
        //let password: String! = tfPassword.text
        
        let url : String! = "http://localhost/homeband-api/api/villes"
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if(response.result.isSuccess){
                    let resultat = response.result.value as! [String:Any]
                    let liste = Mapper<Ville>().mapArray(JSONObject: resultat["liste"])
                    
                    liste?.forEach{ ville in
                        debugPrint(ville.nom)
                    }
                } else {
                    print("Erreur lors de l'appel à l'API !")
                }
                
        }
    }
    
}

