//
//  StyleDaoImpl.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 9/05/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class StyleDaoImpl: StyleDao {
    
    internal let realm:Realm
    
    required init?(){
        self.realm = try! Realm()
    }
    
    func get(key: Int) -> Style? {
        return Style(value: self.realm.object(ofType: Style.self, forPrimaryKey: key) ?? nil!)
    }
    
    func write(obj: Style, update: Bool) {
        try? self.realm.write {
            self.realm.add(obj, update: update)
        }
    }
    
    func list() -> [Style]? {
        return Array(self.realm.objects(Style.self))
    }
    
    func delete(key: Int) {
        
        let obj:Style? = self.realm.object(ofType: Style.self, forPrimaryKey: key)
        if(obj != nil) {
            try? self.realm.write {
                self.realm.delete(obj!)
            }
        }
    }
    

}
