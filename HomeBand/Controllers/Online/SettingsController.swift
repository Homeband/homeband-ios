//
//  SettingsController.swift
//  HomeBand
//
//  Created on 27/01/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import RealmSwift

class SettingsController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPass: UITextField!
    @IBOutlet weak var tfConfirm: UITextField!
    
    
    private let utilisateurDao = UtilisateurDaoImpl()
    private let connectedUser = Tools.getConnectedUser()
    
    override func viewDidLoad() {
        initialisation()
    }
    
    func initialisation(){
        self.tfEmail.delegate = self
        self.tfPass.delegate = self
        self.tfConfirm.delegate = self
        
        self.tfEmail.text = connectedUser?.email
    }
    
    @IBAction func onClickModifier(_ sender: UIButton) {
        let email:String = tfEmail.text!
        let pass:String = tfPass.text!
        let confirm:String = tfConfirm.text!
        
        if(checkEmail(email)){
            connectedUser!.email = tfEmail.text!
            
            if(!(pass.isEmpty) || !(confirm.isEmpty)){
                if(pass.elementsEqual(confirm)){
                    connectedUser!.mot_de_passe = email
                } else {
                    let titre = "Mots de passe incorrects"
                    let msg = "Les deux champs de mot de passe ne sont pas identiques."
                    let alert = UIAlertController(title: titre, message: msg, preferredStyle: .alert)
                    let actionOK = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    alert.addAction(actionOK)
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                connectedUser!.mot_de_passe = ""
            }
            
            let url = Tools.BASE_API_URL + "utilisateurs/" + String(connectedUser!.id_utilisateurs)
            let params:Parameters = [
                "user" : connectedUser!.toDictionary()
            ]
            let headers = Tools.getHeaders()
            
            Alamofire.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                if(response.result.isSuccess){
                    
                    let resultat = response.result.value as! [String:Any]
                    let status = resultat["status"] as! Bool
                    
                    if(status){
                        let user = Mapper<Utilisateur>().map(JSONObject: resultat["user"])!
                        let userDB = self.utilisateurDao?.get(key: user.id_utilisateurs)
                        
                        if(userDB != nil){
                            userDB?.email = user.email
                            userDB?.api_ck = user.api_ck
                            userDB?.login = user.login
                            userDB?.est_connecte = true
                            
                            self.utilisateurDao?.write(obj: userDB!, update: true)
                        }
                        
                        let titre = "Modification effectuée"
                        let msg = "Les modifications demandées ont bien été effectuées."
                        let alert = UIAlertController(title: titre, message: msg, preferredStyle: .alert)
                        let actionOK = UIAlertAction(title: "OK", style: .default, handler: nil)
                        
                        alert.addAction(actionOK)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let titre = "Erreur de modification"
                        let msg = "Une erreur s'est produite lors de la modification des données."
                        let alert = UIAlertController(title: titre, message: msg, preferredStyle: .alert)
                        let actionOK = UIAlertAction(title: "OK", style: .default, handler: nil)
                        
                        alert.addAction(actionOK)
                        self.present(alert, animated: true, completion: nil)
                    }
                } else {
                    let titre = "Erreur de modification"
                    let msg = "Une erreur s'est produite lors de la modification des données."
                    let alert = UIAlertController(title: titre, message: msg, preferredStyle: .alert)
                    let actionOK = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    alert.addAction(actionOK)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else {
            let titre = "E-mail non valide"
            let msg = "L'adresse mail n'est pas valide"
            let alert = UIAlertController(title: titre, message: msg, preferredStyle: .alert)
            let actionOK = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(actionOK)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func onClickDeconnexion(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Déconnexion", message: "Êtes-vous certain de vouloir vous déconnecter ?", preferredStyle: .alert)
        let actionOui = UIAlertAction(title: "Oui", style: .default) { (action:UIAlertAction!) in
            Tools.disconnectUser()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateInitialViewController()
            self.present(controller!, animated: true, completion: nil)
        }
        
        let actionNon = UIAlertAction(title: "Non", style: .cancel, handler: nil)
        
        alert.addAction(actionNon)
        alert.addAction(actionOui)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func checkEmail(_ email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}
