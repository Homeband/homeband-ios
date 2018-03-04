//
//  LoaderController.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 24/02/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import Foundation
import UIKit

class LoaderController: NSObject {
    
    static let sharedInstance = LoaderController()
    private let activityIndicator = UIActivityIndicatorView()
    
    private let loadingView: UIView = UIView()
    private let label: UILabel = UILabel()
    
    
    //MARK: - Private Methods -
    private func setupLoader(text: String) {
        removeLoader()
        
        loadingView.frame = CGRect(x:0, y:-15, width:150, height:80)
        loadingView.backgroundColor = UIColor(hex:0xffffff, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        label.text = text
        label.textAlignment = .center
        label.textColor = .darkGray
        label.frame = CGRect(x:0, y:50, width:150, height:20)
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
    }
    
    //MARK: - Public Methods -
    func showLoader(text: String = "Chargement...") {
        setupLoader(text: text)
        
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let holdingView = appDel.window!.rootViewController!.view!
        
        
        
        DispatchQueue.main.async {
            self.activityIndicator.center = self.loadingView.center
            self.loadingView.center = holdingView.center
            self.loadingView.addSubview(self.activityIndicator)
            self.loadingView.addSubview(self.label)
            
            self.activityIndicator.startAnimating()
            holdingView.addSubview(self.loadingView)
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
    }
    
    func removeLoader(){
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.loadingView.removeFromSuperview()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
}
