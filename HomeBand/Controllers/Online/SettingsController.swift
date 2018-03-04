//
//  SettingsController.swift
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

class SettingsController: UIViewController{
    
    @IBOutlet weak var btnDeconnexion: UIButton!
    
    override func viewDidLoad() {
        print("Ouverture paramètres")
    }
    @IBAction func onClickDeconnexion(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Déconnexion", message: "Êtes-vous certain de vouloir vous déconnecter ?", preferredStyle: .alert)
        let actionOui = UIAlertAction(title: "Oui", style: .default) { (action:UIAlertAction!) in
            Tools.disconnectUser()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateInitialViewController()
            self.present(controller!, animated: true, completion: nil)
        }
        
        let actionNon = UIAlertAction(title: "Non", style: .cancel, handler: nil)
        
        alert.addAction(actionNon)
        alert.addAction(actionOui)
        
        self.present(alert, animated: true, completion: nil)
    }
}
