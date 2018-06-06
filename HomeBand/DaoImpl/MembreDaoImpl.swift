//
//  MembreDaoImpl.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 4/06/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit
import RealmSwift

class MembreDaoImpl: MembreDao {
    
    internal let realm:Realm
    
    required init?(){
        self.realm = try! Realm()
    }
    
    func get(key: Int) -> Membre? {
        return Membre(value: self.realm.object(ofType: Membre.self, forPrimaryKey: key) ?? nil!)
    }
    
    func write(obj: Membre, update: Bool) {
        try? self.realm.write {
            self.realm.add(obj, update: update)
        }
    }
    
    func list() -> [Membre]? {
        return Array(self.realm.objects(Membre.self))
    }
    
    func delete(key: Int) {
        let obj:Membre? = self.realm.object(ofType: Membre.self, forPrimaryKey: key)
        if(obj != nil){
            try? self.realm.write {
                self.realm.delete(obj!)
            }
        }
    }
    
    func listByGroup(_ id_groupes: Int) -> [Membre]? {
        let filter = "id_groupes == " + String(id_groupes)
        let membres:[Membre]? = self.realm.objects(Membre.self).filter(filter).toArray(ofType: Membre.self)
        
        if(membres != nil){
            return [Membre](membres!)
        }
        
        return nil
    }
    
    func deleteByGroup(_ id_groupes: Int) {
        let filter = "id_groupes == " + String(id_groupes)
        try? self.realm.write {
            realm.delete(self.realm.objects(Membre.self).filter(filter))
        }
    }
    

}
