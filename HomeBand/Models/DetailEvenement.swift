//
//  DetailEvenement.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 30/12/17.
//  Copyright © 2017 HEH. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper
import RealmSwift

class DetailEvenement : Object,Mappable {
  @objc dynamic var id_detail_evenement: Int = 0
  @objc dynamic var date_heure: Date = Date()
  @objc dynamic var est_description_perso: Bool = false
  @objc dynamic var desc: String = ""
  @objc dynamic var prix: Double = 0.0
  @objc dynamic var id_evenemnents: Int = 0
  @objc dynamic var id_adresses: Int = 0
  @objc dynamic var est_actif: Bool = true
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        id_detail_evenement <- (map["id_detail_evenement"], IntTransform())
        date_heure <- (map["date_heure"], DateTransform())
        est_description_perso <- (map["est_description_perso"], BooleanTransform())
        desc <- map["description"]
        prix <- (map["prix"], DoubleTransform())
        id_evenemnents <- (map["id_evenemnents"], IntTransform())
        id_adresses <- (map["id_adresses"], IntTransform())
        est_actif <- (map["est_actif"], BooleanTransform())
    }
}
