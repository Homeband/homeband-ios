//
//  TitreDaoImpl.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 4/06/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit
import RealmSwift

class TitreDaoImpl: TitreDao {
    
    internal let realm:Realm
    
    required init?(){
        self.realm = try! Realm()
    }
    
    func get(key: Int) -> Titre? {
        if(key > 0) {
            return Titre(value: self.realm.object(ofType: Titre.self, forPrimaryKey: key) ?? nil!)
        } else {
            return nil
        }
        
    }
    
    func write(obj: Titre, update: Bool) {
        try? self.realm.write {
            self.realm.add(obj, update: update)
        }
    }
    
    func list() -> [Titre]? {
        return Array(self.realm.objects(Titre.self))
    }
    
    func delete(key: Int) {
        let obj:Titre? = self.realm.object(ofType: Titre.self, forPrimaryKey: key)
        if(obj != nil){
            try? self.realm.write {
                self.realm.delete(obj!)
            }
        }
    }
    
    func listByGroup(_ id_groupes: Int) -> [Titre]? {
        let filter = "id_groupes == " + String(id_groupes)
        let titres:[Titre]? = self.realm.objects(Titre.self).filter(filter).toArray(ofType: Titre.self)
        
        if(titres != nil){
            return [Titre](titres!)
        }
        
        return nil
    }
    
    func deleteByGroup(_ id_groupes: Int) {
        let filter = "id_groupes == " + String(id_groupes)
        try? self.realm.write {
            realm.delete(self.realm.objects(Titre.self).filter(filter))
        }
    }

}
