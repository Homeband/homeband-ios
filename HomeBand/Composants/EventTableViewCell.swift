//
//  EventTableViewCell.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 24/05/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var imgEvent: UIImageView!
    @IBOutlet weak var lbNom: UILabel!
    @IBOutlet weak var lbVille: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
