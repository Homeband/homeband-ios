
//
//  EvenementDaoImpl.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 4/06/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit
import RealmSwift

class EvenementDaoImpl: EvenementDao {
    
    internal let realm:Realm
    
    required init?(){
        self.realm = try! Realm()
    }
    
    func get(key: Int) -> Evenement? {
        let event:Evenement? = self.realm.object(ofType: Evenement.self, forPrimaryKey: key)
        
        if(event != nil){
            return Evenement(value: event!)
        }
        
        return nil
    }
    
    func write(obj: Evenement, update: Bool) {
        try? self.realm.write {
            self.realm.add(obj, update: update)
        }
    }
    
    func list() -> [Evenement]? {
        return Array(self.realm.objects(Evenement.self))
    }
    
    func delete(key: Int) {
        let obj:Evenement? = self.realm.object(ofType: Evenement.self, forPrimaryKey: key)
        if(obj != nil){
            try? self.realm.write {
                self.realm.delete(obj!)
            }
        }
    }
    
    func listByUser(id_utilisateurs:Int) -> [Evenement]? {
        let filter = "ANY utilisateurs.id_utilisateurs == " + String(id_utilisateurs)
        return Array(self.realm.objects(Evenement.self).filter(filter).toArray(ofType: Evenement.self))
    }
    
    func listByGroup(id_groupes:Int) -> [Evenement]? {
        let filter = "id_groupes == " + String(id_groupes)
        return Array(self.realm.objects(Evenement.self).filter(filter).toArray(ofType: Evenement.self))
    }
    
    func isUsed(key:Int) -> Bool{
        let event:Evenement? = self.realm.object(ofType: Evenement.self, forPrimaryKey: key)
        if(event != nil){
            return (event!.utilisateurs.count > 0)
        }
        
        return false
    }
    

}
