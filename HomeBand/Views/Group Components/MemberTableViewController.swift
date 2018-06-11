//
//  MemberTableViewController.swift
//  HomeBand
//
//  Created on 17/05/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit

class MemberTableViewController: UITableViewController {
    
    var members:[Membre]!
    
    init(_ membres:[Membre]) {
        self.members = membres
        super.init(nibName:nil, bundle:nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(nibName:nil, bundle:nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("MemberTableViewCell", owner: self, options: nil)?.first as! MemberTableViewCell
        
        let indice = indexPath.row
        
        cell.lbNom?.text = self.members[indice].prenom + " " + self.members[indice].nom
        cell.lbDates?.text = ""

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
