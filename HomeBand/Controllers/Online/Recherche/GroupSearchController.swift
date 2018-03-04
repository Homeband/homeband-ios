//
//  GroupSearchController.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 28/01/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import AlamofireImage
import RealmSwift


class GroupSearchController: UITableViewController{

    
    // MARK : Variables visuelles
    @IBOutlet weak var lbNomGroupe: UILabel!
    @IBOutlet weak var lbVilleGroupe: UILabel!
    @IBOutlet weak var lbStyleGroupe: UILabel!
    
    var searchParams: Parameters = Parameters()
    var groupes: [Groupe]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let cellIdentifier = "GroupCell"
        let cell:SearchGroupTableCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SearchGroupTableCell
        let group:Groupe = self.groupes[indexPath.row]
        
        cell.lbNom.text = group.nom
        cell.lbVille.text = "Châtelineau"
        cell.lbStyle.text = "Rock"
        
        let urlImage = "https://yt3.ggpht.com/pHwZj3tkgC3SJFbuqebBoT7WtVcIwAijEmcbe9VDCauv9ZlG6uS2zjvZQUSO7SfFqa3xjYqGp_L4QbM7=s900-mo-c-c0xffffffff-rj-k-no"
        
        Alamofire.request(urlImage).response{ response in
            guard let imageData = response.data else {
                return
            }
            
            cell.imgIllustration.image = UIImage(data: imageData)
        }
        
        return cell
    }
    
    
}
