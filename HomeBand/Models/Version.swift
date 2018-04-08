//
//  Version.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 16/03/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper
import RealmSwift

class Version: Object,Mappable {
    @objc dynamic var id_versions: Int = 0
    @objc dynamic var num_table: Int = 0
    @objc dynamic var nom_table: String = ""
    @objc dynamic var date_maj: Date = Date()
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        id_versions <- (map["id_versions"], IntTransform())
        num_table <- (map["num_table"], IntTransform())
        nom_table <- map["nom_table"]
        date_maj <- (map["date_maj"], DateTransform())
    }
}
