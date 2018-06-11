//
//  EventInformationsViewController.swift
//  HomeBand
//
//  Created on 4/06/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit

class EventInformationsViewController: UIViewController {
    
    private var event:Evenement!
    private var address:Adresse!
    private var group:Groupe!
    
    private var villeDao:VilleDaoImpl = VilleDaoImpl()!
    private var dateFormatDisplay: DateFormatter = DateFormatter()
    
    
    @IBOutlet weak var lbNom: UILabel!
    @IBOutlet weak var lbNomGroupe: UILabel!
    @IBOutlet weak var lbAdresse: UILabel!
    @IBOutlet weak var lbDateHeure: UILabel!
    @IBOutlet weak var lbPrix: UILabel!
    
    init(event:Evenement, address:Adresse, group:Groupe) {
        self.event = event
        self.address = address
        self.group = group
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialisation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initialisation(){
        var adresseFormat:String
        let ville:Ville = villeDao.get(key: self.address.id_villes)!
        
        // Formatteurs de date
        self.dateFormatDisplay.dateFormat = "dd/MM/YYYY HH:mm"
        
        adresseFormat = self.address.rue.capitalizingFirstLetter() + " " + String(self.address.numero)
        adresseFormat += "\n"
        adresseFormat += ville.code_postal + " " + ville.nom.capitalizingFirstLetter()
        
        self.lbNom.text = self.event.nom
        self.lbNomGroupe.text = self.group.nom
        self.lbAdresse.text = adresseFormat
        self.lbDateHeure.text = self.dateFormatDisplay.string(from: self.event.date_heure)
        
        if(self.event.prix > 0){
            self.lbPrix.text = String(format: "%0.2f", self.event.prix)
        } else {
            self.lbPrix.text = "Gratuit"
        }
    }
    
}
