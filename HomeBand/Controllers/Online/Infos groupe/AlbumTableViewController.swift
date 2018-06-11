//
//  AlbumTableViewController.swift
//  HomeBand
//
//  Created on 6/06/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import Foundation
import UIKit

class AlbumTableViewController: UITableViewController {

    // Variables publiques
    var albums:[Album]!
    
    // Variables
    private let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateFormatter.dateFormat = "dd/MM/yyyy"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albums.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let selectedAlbum = albums[indexPath.row]
        
        let cell = Bundle.main.loadNibNamed("AlbumTableViewCell", owner: self, options: nil)?.first as! AlbumTableViewCell
        
        cell.lbNom.text = selectedAlbum.titre
        cell.lbDateSortie.text = dateFormatter.string(from: selectedAlbum.date_sortie)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    

}
