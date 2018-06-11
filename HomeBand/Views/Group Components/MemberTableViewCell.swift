//
//  MemberTableViewCell.swift
//  HomeBand
//
//  Created on 17/05/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit

class MemberTableViewCell: UITableViewCell {

    @IBOutlet weak var lbNom: UILabel!
    @IBOutlet weak var lbDates: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
}
