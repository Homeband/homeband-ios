//
//  SeachGroupTableCell.swift
//  HomeBand
//
//  Created on 24/02/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import Foundation
import UIKit

class SearchGroupTableCell : UITableViewCell{
    
    @IBOutlet weak var imgIllustration: UIImageView!
    @IBOutlet weak var lbNom: UILabel!
    @IBOutlet weak var lbVille: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
}
