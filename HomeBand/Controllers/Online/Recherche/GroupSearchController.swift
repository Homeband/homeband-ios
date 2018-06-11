//
//  GroupSearchController.swift
//  HomeBand
//
//  Created on 28/01/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Alamofire_Synchronous
import AlamofireObjectMapper
import ObjectMapper
import ImageLoader
import Toucan

class GroupSearchController: UITableViewController{

    // MARK : Variables visuelles
    @IBOutlet weak var lbNomGroupe: UILabel!
    @IBOutlet weak var lbVilleGroupe: UILabel!
    
    var searchParams: Parameters = Parameters()
    var groupes: [Groupe]!
    
    let dateFormatter = DateFormatter()
    let villeDao = VilleDaoImpl()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Rechercher un groupe"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.groupes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = Bundle.main.loadNibNamed("SearchGroupTableCell", owner: self, options: nil)?.first as! SearchGroupTableCell
        
        let group:Groupe = self.groupes[indexPath.row]
        let ville:Ville? = self.villeDao.get(key: group.id_villes)
        
        cell.lbNom.text = group.nom
        cell.lbVille.text = ville!.nom
        
        var urlImg:String = Tools.NO_IMAGE_URL
        
        if(group.illustration != ""){
            urlImg = Tools.BASE_IMAGE_GROUP_URL + group.illustration
        }
        
        // Image
        let imgWidth = cell.imgIllustration.frame.size.width
        let imgHeight = cell.imgIllustration.frame.size.height
        
        cell.imgIllustration.load.request(with: urlImg, onCompletion: { image, error, operation in
            let imageOK = Toucan(image: image!).resize(CGSize(width: imgWidth, height: imgHeight), fitMode: Toucan.Resize.FitMode.crop).image
            
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = kCATransitionFade
                cell.imgIllustration.layer.add(transition, forKey: nil)
                cell.imgIllustration.image = imageOK
        })
        
        return cell
    }
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowGroupDetailSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        LoaderController.sharedInstance.removeLoader()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        LoaderController.sharedInstance.showLoader()
        
        let segueID:String? = segue.identifier
        
        switch(segueID){
        case "ShowGroupDetailSegue":
            // Récupération du groupe sélectionné
            let selectedGroup:Groupe = self.groupes[(tableView.indexPathForSelectedRow?.row)!]
            
            // Paramètres de l'API
            let url:String = Tools.BASE_API_URL + "groupes/" + String(selectedGroup.id_groupes)
            let params:Parameters = [
                "membres" : 1
            ]
            
            // Requête vers l'API
            //LoaderController.sharedInstance.showLoader()
            let response = Alamofire.request(url, method: .get, parameters: params, headers: Tools.getHeaders()).downloadProgress{ progress in
                // Codes at here will not be delayed
                
                
            }.responseJSON()
            
            // Traitement de la réponse
            if(response.result.isSuccess){
                
                // Récupération des résultats
                let resultat = response.result.value as! [String:Any]
                let status:Bool = resultat["status"] as! Bool
                
                if(status){
                    // Récupération de la vue à afficher
                    let destinationViewController = segue.destination as! GroupViewController
                    
                    // Récupération des éléments de l'API
                    let group:Groupe = Mapper<Groupe>().map(JSONObject: resultat["group"])!
                    let members:[Membre] = Mapper<Membre>().mapArray(JSONObject: resultat["members"])!
                    
                    // Passage des valeurs à la vue
                    destinationViewController.group = group
                    destinationViewController.members = members
                    
                    // Modification du titre de la vue et du bouton de retour
                    destinationViewController.title = group.nom
                    navigationItem.title = ""
                    
                } else {
                    print("Erreur de contact avec l'API.")
                }
            } else {
                print("Erreur de contact avec l'API.")
            }
            
            break
        default:
            print("Bad SegueID")
            break
        }
        
        LoaderController.sharedInstance.removeLoader()
    }
}
