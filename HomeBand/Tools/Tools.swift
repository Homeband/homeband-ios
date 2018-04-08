//
//  Tools.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 24/02/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import CryptoSwift


class Tools {
    static let BASE_API_URL : String! = "http://dev.zen-project.be/homeband-api/api/"
    
    class func getHeaders() -> HTTPHeaders{

        let AK:String = "AK"
        let AS:String = "AS"
        let now:Int = Int(NSDate().timeIntervalSince1970)
        var CK:String = ""
        var headers:HTTPHeaders = HTTPHeaders()
        let user:Utilisateur? = getConnectedUser()
        var sign:String
        
        if(user != nil){
            CK = (user?.api_ck)!
        }
        
        // Application Key
        headers.updateValue(AK, forKey: "X-Homeband-AK")
        
        // Timestamp
        headers.updateValue(String(now), forKey: "X-Homeband-TS")
        
        // Customer Key
        headers.updateValue((user?.api_ck)!, forKey: "X-Homeband-CK")
        
        // Signature
        sign = "$1$" + (AS + "+" + String(now) + "+" + CK).sha256()
        headers.updateValue(sign, forKey: "X-Homeband-SIGN")
        
        return headers
    }
    
    class func isUserConnected() -> Bool {
        return (getConnectedUser() != nil)
    }
    
    class func getConnectedUser() -> Utilisateur?
    {
        // On vérifie si un utilisateur est connecté ou non
        let realm = try! Realm()
        let users = realm.objects(Utilisateur.self).filter("est_connecte = 1")
        if(users.count > 0){
            return users.first!
        } else {
            return nil
        }
    }
    
    class func disconnectUser() -> Bool
    {
        let connectedUser: Utilisateur? = self.getConnectedUser()!
        
        if(connectedUser != nil){
            let realm = try! Realm()
            try? realm.write{
                connectedUser?.est_connecte = false
                realm.add(connectedUser!, update: true)
            }
        }
        
        return true
    }
    
    class func checkStylesUpdate(update:Bool = false, displayAlert:Bool = false){
        let urlCheck = Tools.BASE_API_URL + "versions"
        let params:Parameters = [
            "nomtable" : "STYLES"
        ]
        
        // Récupération de la date de la dernière version de la table style
        Alamofire.request(urlCheck, method: .get, parameters: params, headers: Tools.getHeaders()).responseJSON{response in
            if(response.result.isSuccess){
                let resultat = response.result.value as! [String:Any]
                let versionAPI:Version = Mapper<Version>().map(JSONObject: resultat["version"])!
                debugPrint(versionAPI)
                
                let realm = try? Realm()
                let condition = NSPredicate(format: "nom_table like '%@'", versionAPI.nom_table)
                let versionLocale:Version? = (realm?.objects(Version.self).filter(condition).first)
                
                
                if(versionLocale == nil || versionAPI.date_maj > (versionLocale?.date_maj)!){
                    if(update == true){
                        
                    } else if (displayAlert == true){
                        let titre = "Mise à jour disponible"
                        let message = "Une mise à jour des données est disponible. Pour mettre à jour les données, rendez-vous dans les paramètres de l'application."
                        let alert:UIAlertController = UIAlertController(title: titre, message: message, preferredStyle: .alert)
                        let actionOK:UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        
                        alert.addAction(actionOK)
                        
                        let view = UIApplication.topViewController()
                        if(view != nil){
                            view?.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    class func checkVillesUpdate(update:Bool = true) -> Bool{
        return true;
    }
    
    class func checkGroupUpdate(id_groupes:Int = 0, update:Bool = false) -> Bool{
        return true;
    }
    
}
