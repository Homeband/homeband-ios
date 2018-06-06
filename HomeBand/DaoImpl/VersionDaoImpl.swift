//
//  VersionDAO.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 29/04/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit
import RealmSwift

class VersionDaoImpl: VersionDao {
    
    internal let realm:Realm
    
    required init?(){
        self.realm = try! Realm()
    }
    
    func write(obj:Version, update:Bool) {
        // Vérification de la clé primaire
        if(obj.id_versions == 0){
            obj.id_versions = self.getNewId()
        }
        
        try? self.realm.write {
            self.realm.add(obj, update: update)
        }
    }
    
    func get(key:Int) -> Version? {
        return Version(value: self.realm.object(ofType: Version.self, forPrimaryKey: key) ?? nil!)
    }
    
    func list() -> [Version]? {
        return Array(self.realm.objects(Version.self))
    }
    
    func delete(key: Int) {
        let obj:Version? = self.realm.object(ofType: Version.self, forPrimaryKey: key)
        if(obj != nil) {
            try? self.realm.write {
                self.realm.delete(obj!)
            }
        }
    }
    
    func getByNomTable(nom_table:String) -> Version? {
        let filter = NSPredicate(format: "nom_table = %@", nom_table)
        let version:Version? = self.realm.objects(Version.self).filter(filter).first
        
        if(version == nil){
            return nil
        } else {
            return Version(value: version!)
        }
    }
}
