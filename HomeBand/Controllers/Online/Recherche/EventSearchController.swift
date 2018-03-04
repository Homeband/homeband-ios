//
//  File.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 28/01/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import RealmSwift

class EventSearchController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var tfDateStart: UITextField!
    @IBOutlet weak var tfDateEnd: UITextField!
    
    
    override func viewDidLoad() {
        self.tfDateStart.delegate = self
        self.tfDateEnd.delegate = self
    }
    
    // MARK : Gestion des styles et des villes
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    // MARK : Gestion des DatePicker
    @IBAction func dateStartEditing(_ sender: UITextField) {
        dateStartUpdate()
    }
    
    @IBAction func sateEndEditing(_ sender: UITextField) {
        dateEndUpdate()
    }
    
    
    func dateStartUpdate(){
        // Toolbar
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.tintColor = UIColor.hbRed
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Valider", style: .plain, target: self, action: #selector(self.dateStartValidateClick))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        // DatePicker
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.addTarget(self, action: #selector(self.dateStartValueChanged), for: UIControlEvents.valueChanged)
        
        // Ajout de la Toolbar et du DatePicker
        self.tfDateStart.inputAccessoryView = toolbar
        self.tfDateStart.inputView = datePickerView
    }
    
    @objc func dateStartValidateClick(){
        self.tfDateStart.resignFirstResponder()
    }
    
    @objc func dateStartValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        self.tfDateStart.text = dateFormatter.string(from: sender.date)
    }
    
    func dateEndUpdate(){
        // Toolbar
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.tintColor = UIColor.hbRed
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Valider", style: .plain, target: self, action: #selector(self.dateEndValidateClick))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        // DatePicker
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.addTarget(self, action: #selector(self.dateEndValueChanged), for: UIControlEvents.valueChanged)
        
        // Ajout de la Toolbar et du DatePicker
        self.tfDateEnd.inputAccessoryView = toolbar
        self.tfDateEnd.inputView = datePickerView
    }
    
    @objc func dateEndValidateClick(){
        self.tfDateEnd.resignFirstResponder()
    }
    
    @objc func dateEndValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        self.tfDateEnd.text = dateFormatter.string(from: sender.date)
    }
    
    
}
