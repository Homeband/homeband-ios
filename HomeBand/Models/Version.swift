//
//  Version.swift
//  HomeBand
//
//  Created on 16/03/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper
import RealmSwift

class Version: BaseModel,Mappable {
    @objc dynamic var id_versions: Int = 0
    @objc dynamic var num_table: Int = 0
    @objc dynamic var nom_table: String = ""
    @objc dynamic var date_maj: Date = Date()
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        
        if map.mappingType == .toJSON {
            var id_versions = self.id_versions
            id_versions <- (map["id_versions"], IntTransform())
        }
        else {
            id_versions <- (map["id_versions"], IntTransform())
        }
        
        num_table <- (map["num_table"], IntTransform())
        nom_table <- map["nom_table"]
        date_maj <- (map["date_maj"], DateTransform())
    }
    
    override static func primaryKey() -> String? {
        return "id_versions"
    }
}
