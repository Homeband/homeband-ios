//
//  Tools.swift
//  HomeBand
//
//  Created on 24/02/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import CryptoSwift
import CoreLocation


class Tools {
    static let BASE_API_URL : String! = "http://dev.zen-project.be/homeband-api/api/"
    static let BASE_IMAGE_GROUP_URL : String! = "http://dev.zen-project.be/homeband/images/group/"
    static let BASE_IMAGE_EVENT_URL : String! = "http://dev.zen-project.be/homeband/images/event/"
    static let BASE_IMAGE_ALBUM_URL : String! = "http://dev.zen-project.be/homeband/images/album/"
    static let NO_IMAGE_URL : String! = "http://dev.zen-project.be/homeband/images/no_image.png"
    
    class func isAppInitialized() -> Bool {
        // Récupération des préférences
        let preferences = UserDefaults.standard
        
        // Définition de la clé pour l'initialisation
        let firstLaunchKey = "isInitialized"
        
        // Recherche de la clé
        return preferences.bool(forKey: firstLaunchKey)
    }
    
    class func setAppInitialized(isInitialized:Bool) {
        // Récupération des préférences
        let preferences = UserDefaults.standard
        
        // Définition de la clé pour l'initialisation
        let firstLaunchKey = "isInitialized"
        
        // Ajout de la valeur
        preferences.set(isInitialized, forKey: firstLaunchKey)
    }
    
    class func getHeaders() -> HTTPHeaders{

        let AK:String = "zXcD3WS21G0300mqxNaecHvnmy37W4rw"
        let AS:String = "LcBaMofTEoPqBHPwqOJHHOPQ0n9vP6cGxf2PnpbNQW3gELs"
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
        if(CK != "") {
            headers.updateValue(CK, forKey: "X-Homeband-CK")
        }
        
        // Signature
        sign = "$1$" + (AS + "+" + CK + "+" + String(now)).sha256()
        headers.updateValue(sign, forKey: "X-Homeband-SIGN")
        
        headers.updateValue("user", forKey: "X-Homeband-TYPE")
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
            return Utilisateur(value: users.first!)
        } else {
            return nil
        }
    }
    
    class func disconnectUser()
    {
        let connectedUser: Utilisateur? = self.getConnectedUser()!
        
        if(connectedUser != nil){
            let realm = try! Realm()
            try? realm.write{
                connectedUser?.est_connecte = false
                realm.add(connectedUser!, update: true)
            }
        }
    }
    
    class func updateStyles() {
        let url = BASE_API_URL + "styles"
        Alamofire.request(url, method: .get, headers: getHeaders()).responseJSON { response in
            if(response.result.isSuccess){
                let result = response.value as! [String:Any]
                let styles:[Style]? = Mapper<Style>().mapArray(JSONObject: result["styles"])
                
                let realm = try! Realm()
                try? realm.write{
                    if(styles != nil && (styles?.count)! > 0){
                        for style in styles! {
                            realm.add(style, update: true)
                        }
                    }
                }
                
                let versionDao:VersionDaoImpl = VersionDaoImpl()!
                let versionRealm:Version? = versionDao.getByNomTable(nom_table: "STYLES")
                
                let version:Version
                
                if(versionRealm == nil){
                    version = Version()
                    version.num_table = 1
                    version.nom_table = "STYLES"
                } else {
                    version = versionRealm!
                }
                
                version.date_maj = Date()
                versionDao.write(obj: version, update: true)
            }
        }
    }
    
    class func updateVilles() {
        let url = BASE_API_URL + "villes"
        Alamofire.request(url, method: .get, headers: getHeaders()).responseJSON { response in
            if(response.result.isSuccess){
                let result = response.value as! [String:Any]
                let villes:[Ville]? = Mapper<Ville>().mapArray(JSONObject: result["villes"])
                
                let realm = try! Realm()
                try? realm.write{
                    if(villes != nil && (villes?.count)! > 0){
                        for ville in villes! {
                            realm.add(ville, update: true)
                        }
                    }
                }
                
                let versionDao:VersionDaoImpl = VersionDaoImpl()!
                let versionRealm:Version? = versionDao.getByNomTable(nom_table: "VILLES")
                
                let version:Version
                
                if(versionRealm == nil){
                    version = Version()
                    version.num_table = 2
                    version.nom_table = "VILLES"
                } else {
                    version = versionRealm!
                }
                
                version.date_maj = Date()
                versionDao.write(obj: version, update: true)
            }
        }
    }
    
    class func checkReferencesUpdates(completion: @escaping (_ isUpdated:Bool) -> (Void)) {
        let realm = try! Realm()
        realm.beginWrite()
        let versions:[Version] = Array(realm.objects(Version.self))
        var isUpdated:Bool = true
        
        if versions.count > 0 {
            let params:Parameters = [
                "versions" : (versions.map { $0.toDictionary() })
            ]
            let url = BASE_API_URL + "versions/updates"
            
            Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: getHeaders()).responseJSON{ response in
                
                if(response.result.isSuccess){
                    let result = response.value as! [String:Any]
                    let maj_dispo = result["maj_dispo"] as! Bool
                    let versions_maj:[Version] = result["versions"] as! [Version]
                    
                    if(maj_dispo){
                        let title:String = "Mise à jour disponible"
                        let message:String = "Une mise à jour des données est disponible, voulez-vous la télécharger maintenant ?"
                        let alert : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                        let actionOui = UIAlertAction(title: "Oui", style: .default) { (action:UIAlertAction!) in
                            LoaderController.sharedInstance.showLoader(text: "Mise à jour en cours...")
                            for version in versions_maj{
                                switch version.nom_table.uppercased(){
                                case "STYLES" :
                                    updateStyles()
                                    break
                                case "VILLES":
                                    updateVilles()
                                    break
                                default:
                                    break
                                }
                            }
                            LoaderController.sharedInstance.removeLoader()
                        }
                        
                        let actionNon = UIAlertAction(title: "Non", style: .cancel){ (action:UIAlertAction!) in
                            isUpdated = false
                        }
                        
                        // Ajout des action
                        alert.addAction(actionOui)
                        alert.addAction(actionNon)
                        
                        // Récupération de la vue et affichage de l'alerte
                        let view = UIApplication.topViewController()
                        if(view != nil){
                            view?.present(alert, animated: true, completion: nil)
                        }
                    }
                } else {
                    
                }
            }
        }
        
        completion(isUpdated)
    }
}
