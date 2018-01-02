//
//  Evenement.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 30/12/17.
//  Copyright © 2017 HEH. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper
import RealmSwift

class Evenement : Object,Mappable {
  @objc dynamic var id_evenements: Int = 0
  @objc dynamic var nom: String = ""
  @objc dynamic var desc: String = ""
  @objc dynamic var est_actif: Bool = false
  @objc dynamic var id_groupes: Int = 0
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        id_evenements <- (map["id_evenements"], IntTransform())
        nom <- map["nom"]
        desc <- map["description"]
        est_actif <- (map["est_actif"], BooleanTransform())
        id_groupes <- (map["id_groupes"], IntTransform())
    }
}

