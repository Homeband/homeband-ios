//
//  UtilisateurGroupe.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 30/12/17.
//  Copyright © 2017 HEH. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper
import RealmSwift

class UtilisateurGroupe : Object,Mappable {
  @objc dynamic var id_utilisateurs: Int = 0
  @objc dynamic var id_groupes: Int = 0
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        id_utilisateurs <- (map["id_utilisateurs"], IntTransform())
        id_groupes <- (map["id_groupes"], IntTransform())
    }
}
