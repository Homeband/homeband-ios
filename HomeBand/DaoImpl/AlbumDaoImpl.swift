//
//  AlbumDaoImpl.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 4/06/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit
import RealmSwift

class AlbumDaoImpl: AlbumDao {
    
    internal let realm:Realm
    
    required init?(){
        self.realm = try! Realm()
    }
    
    func get(key: Int) -> Album? {
        return Album(value: self.realm.object(ofType: Album.self, forPrimaryKey: key) ?? nil!)
    }
    
    func write(obj: Album, update: Bool) {
        try? self.realm.write {
            self.realm.add(obj, update: update)
        }
    }
    
    func list() -> [Album]? {
        return Array(self.realm.objects(Album.self))
    }
    
    func delete(key: Int) {
        let obj:Album? = self.realm.object(ofType: Album.self, forPrimaryKey: key)
        if(obj != nil){
            try? self.realm.write {
                self.realm.delete(obj!)
            }
        }
    }
    
    func listByGroup(_ id_groupes: Int) -> [Album]? {
        let filter = "id_groupes == " + String(id_groupes)
        let albums:[Album]? = self.realm.objects(Album.self).filter(filter).toArray(ofType: Album.self)
        
        if(albums != nil){
            return [Album](albums!)
        }
        
        return nil
    }
    
    func deleteByGroup(_ id_groupes: Int) {
        let filter = "id_groupes == " + String(id_groupes)
        try? self.realm.write {
            realm.delete(self.realm.objects(Album.self).filter(filter))
        }
        
    }

}
