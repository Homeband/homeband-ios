//
//  AvisTableViewController.swift
//  HomeBand
//
//  Created on 6/06/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit

class AvisTableViewController: UITableViewController {

    // Variables publiques
    var avis:[Avis]!
    var id_groupes:Int!
    
    // Variables
    private let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        tableView.contentInset = UIEdgeInsetsMake(10.0, 0.0, 0.0, 0.0)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 30
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        if(self.avis.isEmpty){
            tableView.backgroundView = NoCommentView()
            tableView.separatorStyle = .none
            return 0
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.avis.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "AvisCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! AvisTableViewCell
        let currentAvis = self.avis[indexPath.row]
        
        cell.lbInfos.text = "Laissé par " + currentAvis.username + " le " + dateFormatter.string(from: currentAvis.date_ajout)
        cell.lbAvis.text = currentAvis.commentaire
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueID = segue.identifier
        switch(segueID){
        case "ShowCommentAdd":
            let destination = segue.destination as! AvisViewController
            destination.id_groupes = self.id_groupes
            
            break
        default:
            print("Bad segue ID")
        }
    }
}
