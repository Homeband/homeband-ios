//
//  Transforms.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 2/01/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

class BooleanTransform : TransformType {
    
    typealias Object = Bool
    typealias JSON = String
    
    func transformFromJSON(_ value: Any?) -> Bool? {
        return ((value as! String) == "1") ? true : false
    }
    
    func transformToJSON(_ value: Bool?) -> String? {
        return (value == true) ? "1" : "0"
    }
}

class IntTransform : TransformType {
    typealias Object = Int
    typealias JSON = Int
    
    func transformFromJSON(_ value: Any?) -> Int? {
        return Int((value as! String))
    }
    
    func transformToJSON(_ value: Int?) -> Int? {
        return value
    }
}

class DoubleTransform : TransformType {
    typealias Object = Double
    typealias JSON = Double
    
    func transformFromJSON(_ value: Any?) -> Double? {
        return Double((value as! String))
    }
    
    func transformToJSON(_ value: Double?) -> Double? {
        return value
    }
}
