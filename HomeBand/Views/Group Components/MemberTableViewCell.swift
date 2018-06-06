//
//  MemberTableViewCell.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 17/05/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit

class MemberTableViewCell: UITableViewCell {

    @IBOutlet weak var lbNom: UILabel!
    @IBOutlet weak var lbDates: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
