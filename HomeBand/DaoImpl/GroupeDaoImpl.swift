//
//  GroupeDaoImpl.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 4/06/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit
import RealmSwift

class GroupeDaoImpl: GroupeDao {
    
    internal let realm:Realm
    
    required init?(){
        self.realm = try! Realm()
    }
    
    func get(key: Int) -> Groupe? {
        let group:Groupe? = self.realm.object(ofType: Groupe.self, forPrimaryKey: key)
        if(group != nil){
            return Groupe(value: group!)
        }
        
        return nil
    }
    
    func write(obj: Groupe, update: Bool) {
        try? self.realm.write {
            self.realm.add(obj, update: update)
        }
    }
    
    func list() -> [Groupe]? {
        return Array(self.realm.objects(Groupe.self))
    }
    
    func delete(key: Int) {
        let obj:Groupe? = self.realm.object(ofType: Groupe.self, forPrimaryKey: key)
        if(obj != nil) {
            try? self.realm.write {
                self.realm.delete(obj!)
            }
        }
    }
    
    func listByUser(id_utilisateurs:Int) -> [Groupe]? {
        let filter = "ANY utilisateurs.id_utilisateurs == " + String(id_utilisateurs)
        return Array(self.realm.objects(Groupe.self).filter(filter).toArray(ofType: Groupe.self))
    }
    
    func isUsed(key:Int) -> Bool{
        let group:Groupe? = self.realm.object(ofType: Groupe.self, forPrimaryKey: key)
        if(group != nil){
            return (group!.evenements.count > 0 || group!.utilisateurs.count > 0)
        }
        
        return false
    }

}
