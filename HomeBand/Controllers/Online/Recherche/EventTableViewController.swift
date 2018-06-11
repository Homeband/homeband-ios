//
//  EventTableViewController.swift
//  HomeBand
//
//  Created on 24/05/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import Alamofire_Synchronous
import AlamofireObjectMapper
import ImageLoader
import Toucan

class EventTableViewController: UITableViewController {

    // Variables publiques
    var events:[Evenement]!
    
    // Variables
    private let dateFormatter = DateFormatter()
    
    // DAO
    private let adresseDao = AdresseDaoImpl()!
    private let villeDao = VilleDaoImpl()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Rechercher un évènement"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("EventTableViewCell", owner: self, options: nil)?.first as! EventTableViewCell
        
        // Récupération de l'évènement courant
        let event = self.events[indexPath.row]
        let ville = self.villeDao.get(key: event.id_villes)
        
        // Liaison de informations à l'interface
        cell.lbNom.text = event.nom
        cell.lbDate.text = dateFormatter.string(from: event.date_heure)
        
        if(ville != nil){
            cell.lbVille.text = ville?.nom
        } else {
            cell.lbVille.text = ""
        }
        
        var urlImg:String = Tools.NO_IMAGE_URL
        
        if(event.illustration != ""){
            urlImg = Tools.BASE_IMAGE_EVENT_URL + event.illustration
        }
        
        let imgWidth = cell.imgEvent.frame.size.width
        let imgHeight = cell.imgEvent.frame.size.height
        
        cell.imgEvent.load.request(with: urlImg, onCompletion: { image, error, operation in
            let imageOK = Toucan(image: image!).resize(CGSize(width: imgWidth, height: imgHeight), fitMode: Toucan.Resize.FitMode.crop).image
            
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionFade
            cell.imgEvent.layer.add(transition, forKey: nil)
            cell.imgEvent.image = imageOK
        })

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowEventDetailSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueID:String? = segue.identifier
        
        switch(segueID){
        case "ShowEventDetailSegue" :
            // Récupération de l'évènement sélectionné
            let selectedEvent:Evenement = self.events[(tableView.indexPathForSelectedRow?.row)!]
            
            // Paramètres de l'API
            let url = Tools.BASE_API_URL + "evenements/" + String(selectedEvent.id_evenements)
            let headers = Tools.getHeaders()
            
            // Appel à l'API
            LoaderController.sharedInstance.showLoader()
            let response = Alamofire.download(url, method: .get, headers: headers).responseJSON()
            LoaderController.sharedInstance.removeLoader()
            
            // Traitement de la réponse
            if(response.result.isSuccess){
                
                // Récupération des résultats
                let resultat = response.result.value as! [String:Any]
                let status:Bool = resultat["status"] as! Bool
                
                if(status){
                    // Récupération de la vue suivante
                    let destinationViewController = segue.destination as! EventViewController
                    
                    // Récupération des éléments de l'API
                    let event:Evenement = Mapper<Evenement>().map(JSONObject: resultat["event"])!
                    let address:Adresse = Mapper<Adresse>().map(JSONObject: resultat["address"])!
                    let group:Groupe = Mapper<Groupe>().map(JSONObject: resultat["group"])!
                    
                    // Passage des valeurs à la vue
                    destinationViewController.event = event
                    destinationViewController.address = address
                    destinationViewController.group = group
                    
                    // Modification du titre de la vue et du bouton de retour
                    destinationViewController.title = event.nom
                    navigationItem.title = ""
                } else {
                    print("Erreur de contact avec l'API.")
                }
            } else {
                print("Erreur de contact avec l'API.")
            }
            break
        default :
            print("Bad Segue ID !")
            break
        }
    }

}
