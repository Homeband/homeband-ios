//
//  Titre.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 30/12/17.
//  Copyright © 2017 HEH. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper
import RealmSwift

class Titre : Object,Mappable {
  @objc dynamic var id_titres: Int = 0
  @objc dynamic var titre: String = ""
  @objc dynamic var date_sortie: Date = Date()
  @objc dynamic var est_actif: Bool = false
  @objc dynamic var id_groupes: Int = 0
  @objc dynamic var id_albums: Int = 0
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        id_titres <- (map["id_titres"], IntTransform())
        titre <- map["titre"]
        date_sortie <- (map["date_sortie"], DateTransform())
        est_actif <- (map["est_actif"], BooleanTransform())
        id_groupes <- (map["id_groupes"], IntTransform())
        id_albums <- (map["id_albums"], IntTransform())
    }
    
    override static func primaryKey() -> String? {
        return "id_titres"
    }
}

