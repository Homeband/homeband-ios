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
    @objc dynamic var date_heure: Date = Date()
    @objc dynamic var prix: Double = 0.0
    @objc dynamic var lien_facebook: String = ""
    @objc dynamic var date_maj: Date = Date()
    @objc dynamic var illustration: Data = Data()
    @objc dynamic var est_actif: Bool = false
    @objc dynamic var id_groupes: Int = 0
    @objc dynamic var id_adresses: Int = 0
    @objc dynamic var id_villes: Int = 0
    let utilisateurs = LinkingObjects(fromType: Utilisateur.self, property: "events")
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        id_evenements <- (map["id_evenements"], IntTransform())
        nom <- map["nom"]
        desc <- map["description"]
        date_heure <- (map["date_heure"], DateTimeTransform())
        prix <- (map["prix"], DoubleTransform())
        lien_facebook <- map["lien_facebook"]
        date_maj <- (map["date_maj"], DateTimeTransform())
        est_actif <- (map["est_actif"], BooleanTransform())
        id_groupes <- (map["id_groupes"], IntTransform())
        id_adresses <- (map["id_adresses"], IntTransform())
        id_villes <- (map["id_villes"], IntTransform())
    }
    
    override static func ignoredProperties() -> [String] {
        return ["id_villes"]
    }
    
    override static func primaryKey() -> String? {
        return "id_evenements"
    }
}

