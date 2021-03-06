//
//  NoCommentView.swift
//  HomeBand
//
//  Created on 6/06/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit

class NoCommentView: UIView {

    @IBOutlet var containerView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialisation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialisation()
    }
    
    func initialisation(){
        Bundle.main.loadNibNamed("NoCommentView", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}
