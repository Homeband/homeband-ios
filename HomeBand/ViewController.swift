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
import RealmSwift

class ViewController: UIViewController {

    @IBOutlet weak var tfLogin: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    
    
    override func viewDidLoad() {
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Realm.Configuration.defaultConfiguration = config
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onClickConnexion(_ sender: Any) {
        let login: String! = tfLogin.text
        let password: String! = tfPassword.text
        let type: Int! = 1; // Connexion de type utilisateur
        
//        let url : String! = "http://localhost/homeband-api/api/villes"
//        Alamofire.request(url, method: .get)
//            .responseJSON { response in
//                if(response.result.isSuccess){
//                    let resultat = response.result.value as! [String:Any]
//                    let liste = Mapper<Ville>().mapArray(JSONObject: resultat["liste"])
//
//                    liste?.forEach{ ville in
//                        debugPrint(ville.nom)
//                    }
//                } else {
//                    print("Erreur lors de l'appel à l'API !")
//                }
//
//        }
        
        let url : String! = "http://localhost/homeband-api/api/sessions"
        let params: Parameters = [
            "login": login,
            "mot_de_passe": password,
            "type": type
        ]
        
        print("Connexion...")
        
        Alamofire.request(url, method: .post, parameters: params)
            .responseJSON { response in
                if(response.result.isSuccess){
                    let resultat = response.result.value as! [String:Any]
                    let message = resultat["message"] as! String
                    let status = resultat["status"] as! Bool
                    if(status){
                        let user: Utilisateur = Mapper<Utilisateur>().map(JSONObject: resultat["user"])!
                        //print("Connexion réussie !")
                        //print("Bienvenue " + user.prenom + " " + user.nom)
                        debugPrint(resultat)
                        debugPrint(user)
                        
                        let realm = try! Realm()
                        
                        try? realm.write{
                            //realm.add(user)
                            
                            //let u: Utilisateur = realm.object(ofType: Utilisateur.self, forPrimaryKey: 1)!
                            //debugPrint(u)
                        }
                        
                    } else {
                        print(message)
                    }
                } else {
                    print("Erreur lors de l'appel à l'API !")
                }
                
        }
    }
    
}

