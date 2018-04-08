//
//  Connectivity.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 4/03/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    class func isConnectedToInternet()->Bool{
        return NetworkReachabilityManager()!.isReachable
    }
    
    class func isConnectedByWifi()->Bool{
        return NetworkReachabilityManager()!.isReachableOnEthernetOrWiFi
    }
    
    class func isConnectedByData()->Bool{
        return NetworkReachabilityManager()!.isReachableOnWWAN
    }
}
