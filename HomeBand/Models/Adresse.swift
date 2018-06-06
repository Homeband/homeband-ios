//
//  Adresse.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 30/12/17.
//  Copyright © 2017 HEH. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper
import RealmSwift

class Adresse : Object,Mappable {
  @objc dynamic var id_adresses: Int = 0
  @objc dynamic var rue: String = ""
  @objc dynamic var numero: Int = 0
  @objc dynamic var boite: String = ""
  @objc dynamic var lat: Double = 0.0
  @objc dynamic var lon: Double = 0.0
  @objc dynamic var id_villes: Int = 0
  @objc dynamic var est_actif: Bool = true
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        id_adresses <- (map["id_adresses"], IntTransform())
        rue <- map["rue"]
        numero <- (map["numero"], IntTransform())
        boite <- map["boite"]
        lat <- (map["lat"], DoubleTransform())
        lon <- (map["lon"], DoubleTransform())
        id_villes <- (map["id_villes"], IntTransform())
        est_actif <- (map["est_actif"], BooleanTransform())
    }
    
    override static func primaryKey() -> String? {
        return "id_adresses"
    }
}

