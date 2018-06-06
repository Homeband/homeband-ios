//
//  VilleDaoImpl.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 9/05/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class VilleDaoImpl: VilleDao {
    
    internal let realm:Realm
    
    required init?(){
        self.realm = try! Realm()
    }
    
    func get(key: Int) -> Ville? {
        if(key > 0) {
            return Ville(value: self.realm.object(ofType: Ville.self, forPrimaryKey: key) ?? nil!)
        } else {
            return nil
        }
    }
    
    func write(obj: Ville, update: Bool) {try? self.realm.write {
            self.realm.add(obj, update: update)
        }
    }
    
    func list() -> [Ville]? {
        return Array(self.realm.objects(Ville.self))
    }
    
    func delete(key: Int) {
        let obj:Ville? = self.realm.object(ofType: Ville.self, forPrimaryKey: key)
        if(obj != nil) {
            try? self.realm.write {
                self.realm.delete(obj!)
            }
        }
    }
    
    
}
