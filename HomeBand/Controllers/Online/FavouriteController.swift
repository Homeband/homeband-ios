//
//  FavouriteController.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 27/01/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import Foundation
import UIKit
import Toucan

class FavouriteController: UITableViewController{
    
    var groupes: [Groupe]!
    
    let groupeDao = GroupeDaoImpl()!
    let membreDao = MembreDaoImpl()!
    let villeDao = VilleDaoImpl()!
    let user = Tools.getConnectedUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.groupes = groupeDao.listByUser(id_utilisateurs: user!.id_utilisateurs)
        tableView.reloadData()
        navigationItem.title = "Mes groupes favoris"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        if(self.groupes.isEmpty){
            tableView.backgroundView = NoGroupView()
            tableView.separatorStyle = .none
            return 0
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
            return 1
        }
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
        
        let urlImage = "http://www.radio2m.ma/wp-content/uploads/2015/11/musique-non-stop2.jpg"
        
        let imgWidth = cell.imgIllustration.frame.size.width
        let imgHeight = cell.imgIllustration.frame.size.height
        
        cell.imgIllustration.load.request(with: urlImage, onCompletion: { image, error, operation in
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
        performSegue(withIdentifier: "ShowFavouriteGroup", sender: self)
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
        case "ShowFavouriteGroup":
            // Récupération du groupe sélectionné
            let selectedGroup:Groupe = self.groupes[(tableView.indexPathForSelectedRow?.row)!]
            
            // Récupération de la vue à afficher
            let destinationViewController = segue.destination as! GroupViewController
            
            // Récupération des éléments de l'API
            let group:Groupe = groupeDao.get(key: selectedGroup.id_groupes)!
            let members:[Membre] = membreDao.listByGroup(selectedGroup.id_groupes)!
            
            // Passage des valeurs à la vue
            destinationViewController.group = group
            destinationViewController.members = members
            
            // Modification du titre de la vue et du bouton de retour
            destinationViewController.title = group.nom
            navigationItem.title = ""
            
            break
        default:
            print("Bad SegueID")
            break
        }
        
        LoaderController.sharedInstance.removeLoader()
    }

}
