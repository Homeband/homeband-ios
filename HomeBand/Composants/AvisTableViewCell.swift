//
//  AvisTableViewCell.swift
//  HomeBand
//
//  Created on 6/06/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit

class AvisTableViewCell: UITableViewCell {

    @IBOutlet weak var lbInfos: UILabel!
    @IBOutlet weak var lbAvis: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
