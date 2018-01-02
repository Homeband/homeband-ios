//
//  Style.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 30/12/17.
//  Copyright © 2017 HEH. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper
import RealmSwift

class Style : Object,Mappable {
  @objc dynamic var id_styles: Int = 0
  @objc dynamic var nom: String = ""
  @objc dynamic var est_actif: Bool = false
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        id_styles <- (map["id_styles"], IntTransform())
        nom <- map["nom"]
        est_actif <- (map["est_actif"], BooleanTransform())
    }
}
