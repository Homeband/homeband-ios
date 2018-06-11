//
//  BaseModdel.swift
//  HomeBand
//
//  Created on 23/04/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper
import RealmSwift

class BaseModel: Object {
    func toDictionary() -> NSDictionary {
        // make dictionary
        var dict = Dictionary<String, Any>()
        
        let properties:[String] = Mirror(reflecting: self).children.compactMap { $0.label }
        
        // add values
        for prop in properties {
            let val:Any! = self.value(forKey: prop)
            if(!(val is ListBase)){
                if (val is String)
                {
                    dict[prop] = val as! String
                }
                else if (val is Int)
                {
                    dict[prop] = val as! Int
                }
                else if (val is Double)
                {
                    dict[prop] = val as! Double
                }
                else if (val is Array<String>)
                {
                    dict[prop] = val as! Array<String>
                } else if (val is Date){
                    let dateformatter = DateFormatter()
                    dateformatter.timeZone = TimeZone(abbreviation: "CEST")
                    dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    dict[prop] = dateformatter.string(from: val as! Date)
                } else {
                    dict[prop] = val
                }
            }
            
        }
        
        // return dict
        return dict as NSDictionary
    }

}
