//
//  Album.swift
//  HomeBand
//
//  Created on 30/12/17.
//  Copyright © 2017 HEH. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper
import RealmSwift

class Album : Object,Mappable {
  @objc dynamic var id_albums: Int = 0
  @objc dynamic var titre: String = ""
  @objc dynamic var image: String = ""
  @objc dynamic var date_sortie: Date = Date()
  @objc dynamic var est_actif: Bool = false
  @objc dynamic var id_groupes: Int = 0
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        id_albums <- (map["id_albums"], IntTransform())
        titre <- map["titre"]
        image <- map["image"]
        date_sortie <- (map["date_sortie"], DateTransform())
        est_actif <- (map["est_actif"], BooleanTransform())
        id_groupes <- (map["id_groupes"], IntTransform())
    }
    
    override static func primaryKey() -> String? {
        return "id_albums"
    }
}

