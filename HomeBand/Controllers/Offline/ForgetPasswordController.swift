//
//  ForgetPasswordController.swift
//  HomeBand
//
//  Created on 10/06/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit
import Alamofire

class ForgetPasswordController: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var tfEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialisation()
        // Do any additional setup after loading the view.
    }
    
    func initialisation(){
        self.tfEmail.delegate = self
    }
    
    @IBAction func onClickValider(_ sender: Any) {
        
        let email:String = tfEmail.text!
        
        if(checkEmail(email)){
            let url = Tools.BASE_API_URL + "utilisateurs/forget"
            let params:Parameters = [
                "email" : email
            ]
            let headers = Tools.getHeaders()
            
            Alamofire.request(url, method: .post, parameters: params, headers: headers).responseJSON { response in
                if(response.result.isSuccess){
                    
                    let resultat = response.result.value as! [String:Any]
                    let status = resultat["status"] as! Bool
                    
                    if(status){
                        let titre = "Opération réussie !"
                        let msg = "Un nouveau mot de passe vous a été envoyé par email."
                        let alert = UIAlertController(title: titre, message: msg, preferredStyle: .alert)
                        let actionOK = UIAlertAction(title: "OK", style: .default){ (action:UIAlertAction!) in
                            self.exitView()
                        }
                        
                        alert.addAction(actionOK)
                        self.present(alert, animated: true, completion: nil)
                    }
                } else {
                    let titre = "E-mail non valide"
                    let msg = "L'adresse mail n'est pas valide"
                    
                    let alert = UIAlertController(title: titre, message: msg, preferredStyle: .alert)
                    let actionOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alert.addAction(actionOK)
                    self.present(alert, animated: true, completion: nil)
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
    
    private func checkEmail(_ email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
}
