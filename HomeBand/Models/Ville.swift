//
//  Ville.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 29/11/17.
//  Copyright © 2017 HEH. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper
import RealmSwift

class Ville : Object,Mappable {
  @objc dynamic var id_villes :Int = 0
  @objc dynamic var nom :String = ""
  @objc dynamic var code_postal :String = ""
  @objc dynamic var lat: Double = 0.0
  @objc dynamic var lon: Double = 0.0
  @objc dynamic var est_actif :Bool = false
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id_villes <- (map["id_villes"], IntTransform())
        nom <- map["nom"]
        code_postal <- map["code_postal"]
        lat <- (map["lat"], DoubleTransform())
        lon <- (map["lon"], DoubleTransform())
        est_actif <- (map["est_actif"], BooleanTransform())
    }
    
    override static func primaryKey() -> String? {
        return "id_villes"
    }

}
