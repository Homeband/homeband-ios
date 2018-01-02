//
//  Membre.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 30/12/17.
//  Copyright © 2017 HEH. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper
import RealmSwift

class Membre : Object,Mappable {
  @objc dynamic var id_membres: Int = 0
  @objc dynamic var nom: String = ""
  @objc dynamic var prenom: String = ""
  @objc dynamic var est_date: Bool = false
  @objc dynamic var date_debut: Date = Date()
  @objc dynamic var date_fin: Date = Date()
  @objc dynamic var est_actif: Bool = true
  @objc dynamic var id_groupes: Int = 0
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        id_membres <- (map["id_membres"], IntTransform())
        nom <- map["nom"]
        prenom <- map["prenom"]
        est_date <- (map["est_date"], BooleanTransform())
        date_debut <- (map["date_debut"], DateTransform())
        date_fin <- (map["date_fin"], DateTransform())
        est_actif <- (map["est_actif"], BooleanTransform())
        id_groupes <- (map["id_groupes"], IntTransform())
    }
}
