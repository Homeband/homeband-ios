//
//  SignupControllerViewController.swift
//  HomeBand
//
//  Created on 9/06/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit
import Alamofire

class SignupController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfLogin: UITextField!
    @IBOutlet weak var tfPass: UITextField!
    @IBOutlet weak var tfConfirmation: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialisation()
    }

    func initialisation(){
        self.tfEmail.delegate = self
        self.tfLogin.delegate = self
        self.tfPass.delegate = self
        self.tfPass.delegate = self
    }
    
    @IBAction func onClickValider(_ sender: Any) {
        
        if(checkForm()){
            let user = Utilisateur()
            user.email = tfEmail.text!
            user.login = tfLogin.text!
            user.mot_de_passe = tfPass.text!
            
            let url = Tools.BASE_API_URL + "utilisateurs"
            let params:Parameters = [
                "user" : user.toDictionary()
            ]
            let headers = Tools.getHeaders()
            
            
            Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                if(response.result.isSuccess){
                    
                    let resultat = response.result.value as! [String:Any]
                    let status = resultat["status"] as! Bool
                    
                    if(status){
                        let titre = "Inscription réussie !"
                        let alert = UIAlertController(title: titre, message: "", preferredStyle: .alert)
                        let actionOK = UIAlertAction(title: "OK", style: .default){ (action:UIAlertAction!) in
                            self.exitView()
                        }
                        
                        alert.addAction(actionOK)
                        self.present(alert, animated: true, completion: nil)
                    }
                } else {
                    
                }
            }
        }
    }
    
    @IBAction func onClickBtnAnnuler(_ sender: Any) {
        exitView()
    }
    
    func exitView(){
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    private func checkForm() -> Bool{
        let login = tfLogin.text
        let email = tfEmail.text
        let pass = tfPass.text
        let confirm = tfConfirmation.text
        
        var titre:String = ""
        var msg:String = ""
        
        if((login?.isEmpty)! || (email?.isEmpty)! || (pass?.isEmpty)! || (confirm?.isEmpty)!){
            titre = "Formulaire incomplet"
            msg = "Vous devez remplir tous les champs pour vous inscrire"
        } else {
            if(!checkEmail(email!)){
                titre = "E-mail non valide"
                msg = "L'adresse mail n'est pas valide"
            } else {
                if(pass != confirm){
                    titre = "Mots de passe incorrects"
                    msg = "Les deux champs de mot de passe ne sont pas identiques"
                } else {
                    return true
                }
            }
        }
        
        let alert = UIAlertController(title: titre, message: msg, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(actionOK)
        self.present(alert, animated: true, completion: nil)
        
        return false
    }

    private func checkEmail(_ email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }

}
