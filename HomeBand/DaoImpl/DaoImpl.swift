//
//  DaoImpl.swift
//  HomeBand
//
//  Created on 1/05/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import Realm
import RealmSwift

extension Dao {
    func getNewId() -> Int {
        let realm = try! Realm()
        let primaryKey: String = E.primaryKey()!
        
        if(realm.objects(E.self).count > 0) {
            let maxId:Int = realm.objects(E.self).max(ofProperty: primaryKey)!
            return 1 + maxId
        } else {
            return 1
        }
    }
}
