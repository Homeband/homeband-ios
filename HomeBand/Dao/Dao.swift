//
//  Dao.swift
//  HomeBand
//
//  Created on 1/05/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

protocol Dao {
    associatedtype K            // Clé primaire
    associatedtype E:Object     // Entité
    
    func get(key:K) -> E?            // Récupére une entité à l'aide de sa clé primaire
    func write(obj:E, update:Bool)  // Ajoute ou met à jour une entité
    func list() -> [E]?              // Récupère toutes les entités de ce type
    func delete(key:K)              // Supprimer une entité à l'aide de sa clé primaire
    
    
}
