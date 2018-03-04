//
//  SearchController.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 27/01/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import RealmSwift

class SearchController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    // MARK: - Elements visuels
    @IBOutlet weak var segTypeRecherche: UISegmentedControl!
    @IBOutlet weak var lblTitre: UILabel!
    @IBOutlet weak var tfStyle: UITextField!
    @IBOutlet weak var tfVille: UITextField!
    @IBOutlet weak var tfDistance: UITextField!
    @IBOutlet weak var stepDistance: UIStepper!
    @IBOutlet weak var tfCodePostal: UITextField!
    
    @IBOutlet weak var swPeriode: UISwitch!
    @IBOutlet weak var lblPeriode: UILabel!
    @IBOutlet weak var lblPeriodeStart: UILabel!
    @IBOutlet weak var tfPeriodeStart: UITextField!
    @IBOutlet weak var lblPeriodeEnd: UILabel!
    @IBOutlet weak var tfPeriodeEnd: UITextField!
    
    
    // MARK: - Variables
    var pickerStyles: UIPickerView = UIPickerView()
    var pickerVilles: UIPickerView = UIPickerView()
    
    var styles: [Style]!
    var villes: [Ville]!
    
    var styleID: Int!
    var villeID: Int!
    
    var lastCP: Int! = 0
    
    var groupesResult : [Groupe]!
    var EventsResult : [Evenement]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialisation()
    }
    
    // MARK: - Traitement sur les éléments
    
    // Switch Groupe/Evenement
    @IBAction func showComponent(_ sender: UISegmentedControl) {
        self.changeEventFieldsVisibility(isVisible: (sender.selectedSegmentIndex != 0))
        
        if(sender.selectedSegmentIndex == 1){
            self.lblTitre.text = "Rechercher un évènement"
        } else {
            self.lblTitre.text = "Rechercher un groupe"
        }
    }
    
    // Stepper Distance
    @IBAction func onChangeStepperDistance(_ sender: UIStepper) {
        self.tfDistance.text = Int(sender.value).description
    }
    
    // Switch Période
    @IBAction func onChangeSwitchPeriode(_ sender: UISwitch) {
        self.tfPeriodeStart.isEnabled = sender.isOn
        self.tfPeriodeEnd.isEnabled = sender.isOn
    }
    
    
    // MARK: - Fonctions  supplémentaires
    func initialisation(){
        self.initStyles()
        self.initVilles()
        self.initDistance()
        
        self.tfCodePostal.delegate = self
        self.tfPeriodeStart.delegate = self
        self.tfPeriodeEnd.delegate = self
        self.tfPeriodeStart.isEnabled = swPeriode.isOn
        self.tfPeriodeEnd.isEnabled = swPeriode.isOn
        
        changeEventFieldsVisibility(isVisible: false)
    }

    func initStyles(){
        self.tfStyle.delegate = self
        self.pickerStyles.delegate = self
        
        let url : String! = "http://localhost/homeband-api/api/styles"
        Alamofire.request(url, method: .get, parameters: nil)
            .responseJSON { response in
                if(response.result.isSuccess){
                    let resultat = response.result.value as! [String:Any]
                    let status = resultat["status"] as! Bool
                    if(status){
                        self.styles = Mapper<Style>().mapArray(JSONObject: resultat["styles"])!
                        self.tfStyle.inputView = self.pickerStyles
                        self.pickerView(self.pickerStyles, didSelectRow: 0, inComponent: 0)
                    }
                }
        }
    }
    
    func initVilles(selectFirst:Bool = true, cp: Int = 0){
        // Delegate
        self.tfVille.delegate = self
        self.pickerVilles.delegate = self
        
        // Contenu
        let url : String! = "http://localhost/homeband-api/api/villes"
        var params: Parameters = [
            "order" : "nom"
        ]
        
        if(cp > 0){
            params.updateValue(cp, forKey: "cp")
        }
        
        Alamofire.request(url, method: .get, parameters: params)
            .responseJSON { response in
                if(response.result.isSuccess){
                    let resultat = response.result.value as! [String:Any]
                    let status = resultat["status"] as! Bool
                    if(status){
                        self.villes = Mapper<Ville>().mapArray(JSONObject: resultat["villes"])!
                        self.tfVille.inputView = self.pickerVilles
                        if(selectFirst){
                            self.pickerView(self.pickerVilles, didSelectRow: 0, inComponent: 0)
                        }
                    }
                }
        }
    }
    
    func initDistance(){
        // Initialisation de la distance
        self.tfDistance.delegate = self
        self.tfDistance.text = Int(stepDistance.value).description
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == pickerStyles){
            return self.styles.count
        } else {
            return self.villes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == pickerStyles){
            return styles[row].nom
        } else {
            return villes[row].nom + " (" + villes[row].code_postal + ")"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == pickerStyles){
            self.tfStyle.text = styles[row].nom
            self.styleID = styles[row].id_styles
        } else {
            self.tfVille.text = villes[row].nom + " (" + villes[row].code_postal + ")"
            self.villeID = villes[row].id_villes
        }
    }
    
    @objc func villesValidateClick(){
        self.tfVille.resignFirstResponder()
    }
    
    @objc func stylesValidateClick(){
        self.tfStyle.resignFirstResponder()
    }
    
    @objc func distanceValidateClick(){
        self.tfDistance.resignFirstResponder()
    }
    
    func changeEventFieldsVisibility(isVisible:Bool!){
        self.swPeriode.isHidden = !isVisible
        self.lblPeriode.isHidden = !isVisible
        self.lblPeriodeStart.isHidden = !isVisible
        self.tfPeriodeStart.isHidden = !isVisible
        self.lblPeriodeEnd.isHidden = !isVisible
        self.tfPeriodeEnd.isHidden = !isVisible
    }
    
    @IBAction func onEditingChangeCodePostal(_ sender: UITextField) {
        if(tfCodePostal.hasText){
            let code_postal: Int! = Int(tfCodePostal.text!)!
            if(code_postal > 999){
                initVilles(selectFirst: (code_postal != lastCP), cp: code_postal)
                lastCP = code_postal
            } else{
                initVilles(selectFirst: false)
            }
        } else
        {
            initVilles(selectFirst: false)
        }
    }
    
    @IBAction func onClickRecherche(_ sender: UIButton) {
        if(Connectivity.isConnectedInternet()){
            if(segTypeRecherche.selectedSegmentIndex == 0){
                searchGroups()
            }
        } else {
            let titreAlerte: String! = "Pas de connexion à internet"
            let messageAlerte: String! = "Une connexion à internet est requise pour effectuer une recherche.\nConnectez-vous à internet afin de continuer"
            
            let alerte: UIAlertController = UIAlertController(title: titreAlerte, message: messageAlerte, preferredStyle: .alert)
            let actionOK: UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alerte.addAction(actionOK)
            
            self.present(alerte, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch(segue.identifier as String!){
        case "searchGroupAction":
            let destination = segue.destination as? GroupSearchController
            destination?.groupes = groupesResult
            break
            
        default:
            break
        }
    }
    
    // Mark : - Fonctions privées
    
    private func searchGroups(){
        LoaderController.sharedInstance.showLoader(text: "Recherche...")
        let url : String! = "http://localhost/homeband-api/api/groupes"
        Alamofire.request(url, method: .get, parameters: nil)
            .responseJSON { response in
                if(response.result.isSuccess){
                    let resultat = response.result.value as! [String:Any]
                    let status = resultat["status"] as! Bool
                    if(status){
                        self.groupesResult = Mapper<Groupe>().mapArray(JSONObject: resultat["groups"])!
                        self.performSegue(withIdentifier: "searchGroupAction", sender: self)
                        LoaderController.sharedInstance.removeLoader()
                    }
                }
                
                LoaderController.sharedInstance.removeLoader()
        }
    }
}


