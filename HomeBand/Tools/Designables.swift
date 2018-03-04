//
//  Designables.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 12/01/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class MyTextField: UITextField {
    
    // Padding left
    @IBInspectable
    var inset: CGFloat = 0
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset, dy: inset)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    
    // Border radius
    @IBInspectable
    var cornerRadius: CGFloat{
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    // Couleurs du placeholder
    @IBInspectable
    var placeholderColor: UIColor{
        get {
            return self.placeholderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue])
        }
    }
}

@IBDesignable class RadiusButton: UIButton {
    // Border radius
    @IBInspectable
    var cornerRadius: CGFloat{
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}

@IBDesignable class GradientView: UIView {
    @IBInspectable var topColor: UIColor = UIColor.white
    @IBInspectable var bottomColor: UIColor = UIColor.black
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        (layer as! CAGradientLayer).colors = [topColor.cgColor, bottomColor.cgColor]
    }
}

@IBDesignable class MyTabBar: UITabBar{
    
    @IBInspectable var unselectedTint: UIColor = UIColor.clear {
        didSet {
            self.unselectedItemTintColor = unselectedTint
        }
    }
}
