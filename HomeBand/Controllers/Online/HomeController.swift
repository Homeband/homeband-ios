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

class HomeController: UITableViewController{
    
    var events:[Evenement]!
    var user = Tools.getConnectedUser()!
    
    private let evenementDao = EvenementDaoImpl()!
    private let groupeDao = GroupeDaoImpl()!
    private let adresseDao = AdresseDaoImpl()!
    private let villeDao = VilleDaoImpl()!
    
    private var dateFormatter:DateFormatter!
    
    override func viewDidLoad() {
        
        if(!Tools.isAppInitialized()){
            LoaderController.sharedInstance.showLoader()
            Tools.updateStyles()
            Tools.updateVilles()
            LoaderController.sharedInstance.removeLoader()
        } else {
            
            //if(Tools.getReferencesUpdates(completion: <#T##([Version]) -> ()#>))
        }
        
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "dd/MM/YYYY HH:mm"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Homeband"
        self.events = self.evenementDao.listByUser(id_utilisateurs: self.user.id_utilisateurs)
        tableView.reloadData()
        
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        if(self.events.isEmpty){
            tableView.backgroundView = NoEventView()
            tableView.separatorStyle = .none
            return 0
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("EventTableViewCell", owner: self, options: nil)?.first as! EventTableViewCell
        
        // Récupération de l'évènement courant et des informations
        let event = self.events[indexPath.row]
        let address = self.adresseDao.get(key: event.id_adresses)
        let ville = self.villeDao.get(key: address!.id_villes)
        
        // Liaison de informations à l'interface
        cell.lbNom.text = event.nom
        
        if(ville != nil){
            cell.lbVille.text = ville?.nom
        } else {
            cell.lbVille.text = ""
        }
        
        cell.lbDate.text = self.dateFormatter.string(from: event.date_heure)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowFavouriteEvent", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Évènements à venir"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueID:String? = segue.identifier
        
        switch(segueID){
        case "ShowFavouriteEvent" :
            // Récupération de l'évènement sélectionné
            let selectedEvent:Evenement = self.events[(tableView.indexPathForSelectedRow?.row)!]
            
            // Récupération de la vue suivante
            let destinationViewController = segue.destination as! EventViewController
            
            // Récupération des éléments de l'API
            let event:Evenement = self.evenementDao.get(key: selectedEvent.id_evenements)!
            let address:Adresse = self.adresseDao.get(key: selectedEvent.id_adresses)!
            let group:Groupe = self.groupeDao.get(key: selectedEvent.id_groupes)!
            
            // Passage des valeurs à la vue
            destinationViewController.event = event
            destinationViewController.address = address
            destinationViewController.group = group
            
            // Modification du titre de la vue et du bouton de retour
            destinationViewController.title = event.nom
            navigationItem.title = ""
            
            break
        default :
            print("Bad Segue ID !")
            break
        }
    }
}
