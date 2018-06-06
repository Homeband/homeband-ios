//
//  AdresseDaoImpl.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 4/06/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit
import RealmSwift

class AdresseDaoImpl: AdresseDao {
    
    internal let realm:Realm
    
    required init?(){
        self.realm = try! Realm()
    }
    
    func get(key: Int) -> Adresse? {
        if(key > 0) {
            let address:Adresse? = self.realm.object(ofType: Adresse.self, forPrimaryKey: key)
            if(address != nil){
                return Adresse(value: address!)
            }
        }
        return nil
    }
    
    func write(obj: Adresse, update: Bool) {
        try? self.realm.write {
            self.realm.add(obj, update: update)
        }
    }
    
    func list() -> [Adresse]? {
        return Array(self.realm.objects(Adresse.self))
    }
    
    func delete(key: Int) {
        let obj:Adresse? = self.realm.object(ofType: Adresse.self, forPrimaryKey: key)
        if(obj != nil) {
            try? self.realm.write {
                self.realm.delete(obj!)
            }
        }
    }
    

}
