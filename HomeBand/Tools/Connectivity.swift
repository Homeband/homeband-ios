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
    class func isConnectedInternet()->Bool{
        return NetworkReachabilityManager()!.isReachable
    }
}
