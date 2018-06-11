//
//  UtilisateurDaoImpl.swift
//  HomeBand
//
//  Created on 5/06/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit
import RealmSwift

class UtilisateurDaoImpl: UtilisateurDao {
    
    internal let realm:Realm
    
    required init?(){
        self.realm = try! Realm()
    }
    
    func get(key: Int) -> Utilisateur? {
        if(key > 0) {
            let user:Utilisateur? = self.realm.object(ofType: Utilisateur.self, forPrimaryKey: key)
            if(user != nil) {
                return Utilisateur(value: user!)
            }
        }
        
        return nil
    }
    
    func write(obj: Utilisateur, update: Bool) {
        try? self.realm.write {
            self.realm.add(obj, update: update)
        }
    }
    
    func list() -> [Utilisateur]? {
        return Array(self.realm.objects(Utilisateur.self))
    }
    
    func delete(key: Int) {
        print("delete group")
    }
    
    func addGroup(id_utilisateurs: Int, group: Groupe) {
        if(id_utilisateurs > 0){
            let user:Utilisateur? = self.realm.object(ofType: Utilisateur.self, forPrimaryKey: id_utilisateurs)
            if(user != nil){
                var groupAdd:Groupe? = self.realm.object(ofType: Groupe.self, forPrimaryKey: group.id_groupes)
                if(groupAdd == nil){
                    groupAdd = group
                }
                
                try? self.realm.write {
                    user?.groups.append(groupAdd!)
                }
            }
        }
    }
    
    func deleteGroup(id_utilisateurs: Int, id_groupes: Int) {
        if(id_utilisateurs > 0){
            let user:Utilisateur? = self.realm.object(ofType: Utilisateur.self, forPrimaryKey: id_utilisateurs)
            if(user != nil){
                //
                let filter = "id_groupes == " + String(id_groupes)
                let group:Groupe? = user!.groups.filter(filter).first
                if(group != nil){
                    let pos = user!.groups.index(of: group!)
                    try? self.realm.write {
                        user!.groups.remove(at: pos!)
                        
                        if(group!.utilisateurs.count == 0 && group!.evenements.count == 0){
                            realm.delete(group!)
                        }
                    }
                }
            }
        }
    }
    
    func getGroup(id_utilisateurs:Int, id_group: Int) -> Groupe? {
        if(id_utilisateurs > 0){
            let user:Utilisateur? = self.realm.object(ofType: Utilisateur.self, forPrimaryKey: id_utilisateurs)
            if(user != nil){
                //
                let filter = "id_groupes == " + String(id_group)
                let group:Groupe? = user!.groups.filter(filter).first
                if(group != nil){
                    return Groupe(value: group!)
                }
            }
        }
        
        return nil
    }
    
    func addEvent(id_utilisateurs: Int, event: Evenement) {
        if(id_utilisateurs > 0){
            let user:Utilisateur? = self.realm.object(ofType: Utilisateur.self, forPrimaryKey: id_utilisateurs)
            if(user != nil){
                var eventAdd:Evenement? = self.realm.object(ofType: Evenement.self, forPrimaryKey: event.id_evenements)
                if(eventAdd == nil){
                    eventAdd = Evenement(value: event)
                }
                
                try? self.realm.write {
                    user?.events.append(eventAdd!)
                }
            }
        }
    }
    
    func deleteEvent(id_utilisateurs: Int, id_evenements: Int) {
        if(id_utilisateurs > 0){
            let user:Utilisateur? = self.realm.object(ofType: Utilisateur.self, forPrimaryKey: id_utilisateurs)
            if(user != nil){
                //
                let filter = "id_evenements == " + String(id_evenements)
                let event:Evenement? = user!.events.filter(filter).first
                if(event != nil){
                    let pos = user!.events.index(of: event!)
                    try? self.realm.write {
                        user!.events.remove(at: pos!)
                        
                        if(event!.utilisateurs.count == 0){
                            realm.delete(event!)
                        }
                    }
                }
            }
        }
    }
    
    func getEvent(id_utilisateurs:Int, id_evenements: Int) -> Evenement? {
        if(id_utilisateurs > 0){
            let user:Utilisateur? = self.realm.object(ofType: Utilisateur.self, forPrimaryKey: id_utilisateurs)
            if(user != nil){
                //
                let filter = "id_evenements == " + String(id_evenements)
                let event:Evenement? = user!.events.filter(filter).first
                if(event != nil){
                    return Evenement(value: event!)
                }
            }
        }
        
        return nil
    }
}
