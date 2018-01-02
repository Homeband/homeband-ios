//
//  Utilisateur.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 30/12/17.
//  Copyright © 2017 HEH. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper
import RealmSwift

class Utilisateur : Object,Mappable {
    @objc dynamic var id_utilisateurs: Int = 0
    @objc dynamic var login: String = ""
    @objc dynamic var mot_de_passe: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var nom: String = ""
    @objc dynamic var prenom: String = ""
    @objc dynamic var est_actif: Bool = false
    @objc dynamic var api_ck: String = ""
    @objc dynamic var id_adresses: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }

    
    func mapping(map: Map) {
        id_utilisateurs <- (map["id_utilisateurs"], IntTransform())
        login <- map["login"]
        mot_de_passe <- map["mot_de_passe"]
        email <- map["email"]
        nom <- map["nom"]
        prenom <- map["prenom"]
        est_actif <- (map["est_actif"], BooleanTransform())
        api_ck <- map["api_ck"]
        id_adresses <- (map["id_adresses"], IntTransform())
    }
    
    override static func primaryKey() -> String? {
        return "id_utilisateurs"
    }
}

