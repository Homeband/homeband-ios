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


class Tools {
    
    static func getConnectedUser() -> Utilisateur?
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
    
    static func disconnectUser() -> Bool
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
}
