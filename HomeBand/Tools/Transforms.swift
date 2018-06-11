//
//  Transforms.swift
//  HomeBand
//
//  Created on 2/01/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

class BooleanTransform : TransformType {
    
    typealias Object = Bool
    typealias JSON = String
    
    func transformFromJSON(_ value: Any?) -> Bool? {
        if(value == nil){
            return false
        } else if(value is Bool){
            return value as? Bool
        } else {
            return ((value as! String) == "1") ? true : false
        }
    }
    
    func transformToJSON(_ value: Bool?) -> String? {
        return (value == true) ? "1" : "0"
    }
}

class IntTransform : TransformType {
    typealias Object = Int
    typealias JSON = Int
    
    func transformFromJSON(_ value: Any?) -> Int? {
        if(value == nil){
            return 0
        } else if(value is Int){
            return value as? Int
        } else {
            return Int((value as! String))
        }
    }
    
    func transformToJSON(_ value: Int?) -> Int? {
        return value
    }
}

class DoubleTransform : TransformType {
    typealias Object = Double
    typealias JSON = Double
    
    func transformFromJSON(_ value: Any?) -> Double? {
        if(value == nil){
            return 0
        } else if(value is Double){
            return value as? Double
        } else {
            return Double((value as! String))
        }
    }
    
    func transformToJSON(_ value: Double?) -> Double? {
        return value
    }
}

class DateTimeTransform : TransformType {
    typealias Object = Date
    typealias JSON = Date
    
    func transformFromJSON(_ value: Any?) -> Date? {
        if(value == nil){
            return nil
        } else if(value is Date){
            return value as? Date
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:SS"
            return formatter.date(from: (value as! String))
        }
    }
    
    func transformToJSON(_ value: Date?) -> Date? {
        return value
    }
}
