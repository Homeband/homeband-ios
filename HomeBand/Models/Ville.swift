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

class Ville : Mappable {
    var id_villes :Int = 0
    var nom :String = ""
    var code_postal :String = ""
    var est_actif :Bool = false
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id_villes <- map["id_villes"]
        nom <- map["nom"]
        code_postal <- map["code_postal"]
        est_actif <- map["est_actif"]
    }
}
