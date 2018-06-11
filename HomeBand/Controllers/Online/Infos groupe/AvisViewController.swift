//
//  AvisViewController.swift
//  HomeBand
//
//  Created on 6/06/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit
import Alamofire

class AvisViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var tvAvis: CustomTextView!
    
    var id_groupes:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tvAvis.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickEnvoyer(_ sender: Any) {
        
        if(Connectivity.isConnectedToInternet()){
            let comment:Avis = Avis()
            let user = Tools.getConnectedUser()
            
            comment.commentaire = tvAvis.text
            comment.date_ajout = Date()
            comment.id_utilisateurs = user!.id_utilisateurs
            comment.id_groupes = self.id_groupes
            comment.est_accepte = false
            comment.est_verifie = false
            comment.est_actif = true
            
            let url = Tools.BASE_API_URL + "groupes/" + String(id_groupes) + "/avis"
            let headers = Tools.getHeaders()
            let params:[String: Any] = [
                "comment" : comment.toDictionary()
            ]
            
            LoaderController.sharedInstance.showLoader()
            Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                if(response.result.isSuccess){
                    
                    let resultat = response.result.value as! [String:Any]
                    let status = resultat["status"] as! Bool
                    
                    if(status){
                        let title = "Merci !"
                        let msg = "Votre avis a bien été envoyé et sera visible après avoir été validé."
                        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
                        let actionOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alert.addAction(actionOK)
                        
                        self.present(alert, animated: true, completion: nil)
                        _ = self.navigationController?.popViewController(animated: true)
                    } else {
                        let title = "Oups !"
                        let msg = "Une erreur est survenue lors de l'envoi de votre avis.\nVeuillez réessayer plus tard."
                        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
                        let actionOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alert.addAction(actionOK)
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                } else {
                    let title = "Oups !"
                    let msg = "Une erreur est survenue lors de l'envoi de votre avis.\nVeuillez réessayer plus tard."
                    let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
                    let actionOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(actionOK)
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
                LoaderController.sharedInstance.removeLoader()
            }
        } else {
            let title = "Pas de connexion"
            let msg = "Vous devez être connecté à internet afin d'envoyer un avis."
            let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            let actionOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(actionOK)
            
            self.present(alert, animated: true, completion: nil)
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
