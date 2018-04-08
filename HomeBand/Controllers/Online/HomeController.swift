//
//  HomeController.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 27/01/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import RealmSwift

class HomeController: UIViewController{
    
    override func viewDidLoad() {
        Tools.checkStylesUpdate(update: false, displayAlert: true)
        print(Tools.getHeaders())
    }
}
