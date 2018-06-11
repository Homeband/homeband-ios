//
//  Avis.swift
//  HomeBand
//
//  Created on 30/12/17.
//  Copyright © 2017 HEH. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper
import RealmSwift

class Avis : BaseModel,Mappable {
  @objc dynamic var id_avis: Int = 0
  @objc dynamic var commentaire: String = ""
  @objc dynamic var est_verifie: Bool = false
  @objc dynamic var est_accepte: Bool = false
  @objc dynamic var date_ajout: Date = Date()
  @objc dynamic var date_validation: Date = Date()
  @objc dynamic var est_actif: Bool = false
  @objc dynamic var id_utilisateurs: Int = 0
  @objc dynamic var id_groupes: Int = 0
  @objc dynamic var username:String = ""
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        id_avis <- (map["id_avis"], IntTransform())
        commentaire <- map["commentaire"]
        est_verifie <- (map["est_verifie"], BooleanTransform())
        est_accepte <- (map["est_accepte"], BooleanTransform())
        date_ajout <- (map["date_ajout"], DateTimeTransform())
        date_validation <- (map["date_validation"], DateTimeTransform())
        est_actif <- (map["est_actif"], BooleanTransform())
        id_utilisateurs <- (map["id_utilisateurs"], IntTransform())
        id_groupes <- (map["id_groupes"], IntTransform())
        username <- (map["username"])
    }
    
    override static func primaryKey() -> String? {
        return "id_avis"
    }
}

