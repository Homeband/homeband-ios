//
//  GroupContactView.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 12/05/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit

class GroupContactView: UIViewController {

    private var group:Groupe!
    
    @IBOutlet weak var tvContact: UITextView!
    
    init(_ group:Groupe) {
        self.group = group
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initContact()
        // Do any additional setup after loading the view.
    }

    func initContact(){
        self.tvContact.text = self.group.contacts
    }
    
}
