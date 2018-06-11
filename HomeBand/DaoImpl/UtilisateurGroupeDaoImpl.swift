//
//  UtilisateurGroupeDaoImpl.swift
//  HomeBand
//
//  Created on 4/06/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit
import RealmSwift

class UtilisateurGroupeDaoImpl: UtilisateurGroupeDao {
    
    internal let realm:Realm
    
    required init?(){
        self.realm = try! Realm()
    }
    
    func get(key: (id_utilisateurs:Int, id_groupes:Int)) -> UtilisateurGroupe? {
        let filter = "id_groupes == " + String(key.id_groupes) + " and id_utilisateurs == " + String(key.id_utilisateurs)
        let utilisateurGroupe:UtilisateurGroupe? = self.realm.objects(UtilisateurGroupe.self).filter(filter).first
        
        if(utilisateurGroupe == nil){
            return nil
        } else {
            return UtilisateurGroupe(value: utilisateurGroupe!)
        }
    }
    
    func write(obj: UtilisateurGroupe, update: Bool) {
        try? self.realm.write {
            self.realm.add(obj, update: false)
        }
    }
    
    func list() -> [UtilisateurGroupe]? {
        return [UtilisateurGroupe](realm.objects(UtilisateurGroupe.self))
    }
    
    func delete(key: (id_utilisateurs:Int, id_groupes:Int)) {
        //let filter = NSPredicate(format: "id_groupes = %@ && id_utilisateurs = %@", key.id_groupes, key.id_utilisateurs)
        let filter = "id_groupes == " + String(key.id_groupes) + " and id_utilisateurs == " + String(key.id_utilisateurs)
        let obj:UtilisateurGroupe? = self.realm.objects(UtilisateurGroupe.self).filter(filter).first
        
        if(obj == nil){
            try? self.realm.write {
                self.realm.delete(obj!)
            }
        }
    }
    

}
