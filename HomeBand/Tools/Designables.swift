//
//  Designables.swift
//  HomeBand
//
//  Created on 12/01/18.
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

@IBDesignable
class CustomImageButton: RadiusButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if imageView != nil {
            imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: (bounds.width - 35))
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (imageView?.frame.width)!)
        }
    }
}

@IBDesignable
class CustomTextView:UITextView{
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornurRadius: CGFloat = 1.0 {
        didSet {
            layer.cornerRadius = cornurRadius
            clipsToBounds = true
        }
    }
}

