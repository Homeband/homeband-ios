//
//  ViewController.swift
//  HomeBand
//
//  Created on 16/11/17.
//  Copyright © 2017 HEH. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import RealmSwift

class LoginController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tfLogin: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private let loginAction: String = "LoginTransition"
    private let inscriptionAction: String = "InscriptionTransition"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tfLogin.delegate = self
        self.tfPassword.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //tfLogin.text = "Nicolas"
        //tfPassword.text = "Test123*"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == tfLogin){
            tfPassword.becomeFirstResponder()
            return true
        }
        
        self.view.endEditing(true)
        return false
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident:String = identifier{
            switch ident {
            case "LoginTransition" :
                connexion(sender:sender)
                
            case "SignupTransition" :
                return true
            
            case "ForgetPasswordSegue" :
                return true
                
            default :
                print("Identifiant inconnu !")
            }
        }
        
        return false
    }
    
    func connexion(sender: Any?){
        // Variables
        let login: String! = tfLogin.text
        let password: String! = tfPassword.text
        let type: Int! = 1; // Connexion de type utilisateur
        let url : String! = Tools.BASE_API_URL + "sessions"
        
        let params: Parameters = [
            "login": login as String,
            "mot_de_passe": password as String,
            "type": type as Int
        ]
        
        LoaderController.sharedInstance.showLoader(text: "Connexion...")
        
        Alamofire.request(url, method: .post, parameters: params, headers: Tools.getHeaders())
            .responseJSON { response in
                if(response.result.isSuccess){
                    let resultat = response.result.value as! [String:Any]
                    print(resultat)
                    let message = resultat["message"] as! String
                    let status = resultat["status"] as! Bool
                    if(status){
                        let user: Utilisateur = Mapper<Utilisateur>().map(JSONObject: resultat["user"])!
                        debugPrint(resultat)
                        debugPrint(user)
                        
                        let realm = try! Realm()
                        
                        try? realm.write{
                            user.est_connecte = true
                            let userDB:Utilisateur? = realm.object(ofType: Utilisateur.self, forPrimaryKey: user.id_utilisateurs)
                            if(userDB != nil) {
                                userDB!.api_ck = user.api_ck
                                userDB!.email = user.email
                                userDB!.est_connecte = true
                            } else {
                                realm.add(user, update: true)
                            }
                        }
                        
                        LoaderController.sharedInstance.removeLoader()
                        self.performSegue(withIdentifier: "LoginTransition", sender: sender)
                    } else {
                        LoaderController.sharedInstance.removeLoader()
                        let alert2 = UIAlertController(title: "Echec de la connexion", message: message, preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                        
                        alert2.addAction(action)
                        
                        self.present(alert2, animated: false, completion: nil)
                    }
                } else {
                    
                    LoaderController.sharedInstance.removeLoader()
                    let alert = UIAlertController(title: "Echec de la connexion", message: "Erreur lors de l'appel à l'API !", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)

                    alert.addAction(action)
                    self.present(alert, animated: false, completion: nil)
                }
        }
    }
    
    func inscription(sender: Any?){
        
    }
}

