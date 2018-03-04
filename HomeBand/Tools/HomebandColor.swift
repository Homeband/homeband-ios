//
//  HomebandColor.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 28/01/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit

extension UIColor{
    
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    
    
    convenience init(hex:Int, alpha: CGFloat = 1.0){
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff, alpha: alpha)
    }
    
    static let hbRed = UIColor(hex:0xCE2828)
}
