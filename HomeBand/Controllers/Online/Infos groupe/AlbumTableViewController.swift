//
//  AlbumTableViewController.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 6/06/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit

class AlbumTableViewController: UITableViewController {

    var albums:[Album]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let cellID = "AlbumCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! AlbumTableViewCell
        
        cell.lbNom.text = selectedAlbum.titre
        
        return cell
    }
    

}
