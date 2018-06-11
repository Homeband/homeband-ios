//
//  EventDescriptionViewController.swift
//  HomeBand
//
//  Created on 4/06/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit

class EventDescriptionViewController: UIViewController {

    private var event:Evenement!
    
    @IBOutlet weak var tvDescription: UITextView!
    
    init(_ event:Evenement) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialisation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func initialisation(){
        self.tvDescription.text = self.event.desc
    }

}
