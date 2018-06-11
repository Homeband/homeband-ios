//
//  SearchController.swift
//  HomeBand
//
//  Created on 27/01/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Alamofire_Synchronous
import AlamofireObjectMapper
import ObjectMapper
import RealmSwift
import CoreLocation

class SearchController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate{
    
    // MARK: - Elements visuels
    @IBOutlet weak var segTypeRecherche: UISegmentedControl!
    @IBOutlet weak var lblTitre: UILabel!
    @IBOutlet weak var tfStyle: UITextField!
    @IBOutlet weak var tfAdresse: UITextField!
    @IBOutlet weak var tfDistance: UITextField!
    @IBOutlet weak var stepDistance: UIStepper!
    
    @IBOutlet weak var swPeriode: UISwitch!
    @IBOutlet weak var lblPeriode: UILabel!
    @IBOutlet weak var lblPeriodeStart: UILabel!
    @IBOutlet weak var tfPeriodeStart: UITextField!
    @IBOutlet weak var lblPeriodeEnd: UILabel!
    @IBOutlet weak var tfPeriodeEnd: UITextField!
    
    
    // MARK: - Variables
    private var pickerStyles: UIPickerView = UIPickerView()
    private var pickerDateFrom: UIDatePicker = UIDatePicker()
    private var pickerDateTo: UIDatePicker = UIDatePicker()
    private var dateFormatDisplay: DateFormatter = DateFormatter()
    private var dateFormatAPI: DateFormatter = DateFormatter()

    private var styles: [Style]!
    
    private var styleID: Int!
    private var groupesResult : [Groupe]!
    private var eventsResult : [Evenement]!
    
    private var locationManager: CLLocationManager!
    
    private var lat:Double!
    private var long:Double!
    
    private var styleDao:StyleDaoImpl = StyleDaoImpl()!
    
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
        var distance:Int = Int(sender.value)
        let mod = distance % 10
        if(mod > 0){
            if(mod < 5){
                distance += 5 - mod
            } else if (mod > 5) {
                distance += 10 - mod
            }
        }
        
        self.tfDistance.text = String(distance)
    }
    
    @IBAction func tfDistanceDidEndEditing(_ sender: UITextField) {
        
        let distance:Int = (Int(self.tfDistance.text!) ?? 0)
        if(distance < 5){
            self.tfDistance.text = "5"
        } else if(distance > 250){
            self.tfDistance.text = "250"
        }
    }
    
    // Switch Période
    @IBAction func onChangeSwitchPeriode(_ sender: UISwitch) {
        self.tfPeriodeStart.isEnabled = sender.isOn
        self.tfPeriodeStart.isHidden = !sender.isOn
        self.lblPeriodeStart.isHidden = !sender.isOn
        
        self.tfPeriodeEnd.isEnabled = sender.isOn
        self.tfPeriodeEnd.isHidden = !sender.isOn
        self.lblPeriodeEnd.isHidden = !sender.isOn
    }

    // Clic sur le bouton recherche
    @IBAction func onClickRecherche(_ sender: UIButton) {
        if(Connectivity.isConnectedToInternet()){
            if(segTypeRecherche.selectedSegmentIndex == 0){
                searchGroups()
            } else {
                searchEvents()
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
    
    @IBAction func onClickLocation(_ sender: UIButton) {
        getUserLocation()
    }
    
    @IBAction func dateStartDidEndEditing(_ sender: UITextField) {
        updateDateFrom()
    }
    
    @IBAction func dateEndDidEndEditing(_ sender: UITextField) {
        updateDateTo()
    }
    
    // MARK: - Fonctions  supplémentaires
    func initialisation(){
        self.initStyles()
        self.initDistance()
        self.initLocation()
        self.initDates()
        
        self.tfAdresse.delegate = self
        
        changeEventFieldsVisibility(isVisible: false)
    }

    func initStyles(){
        self.tfStyle.delegate = self
        self.pickerStyles.delegate = self
        
        let allStyles:Style = Style()
        allStyles.id_styles = 0
        allStyles.nom = "Tous les styles"
        
        self.styles = styleDao.list()
        self.styles.insert(allStyles, at: 0)
        
        self.tfStyle.inputView = self.pickerStyles
        self.pickerView(self.pickerStyles, didSelectRow: 0, inComponent: 0)
    }
    
    func initDistance(){
        // Initialisation de la distance
        self.tfDistance.delegate = self
        self.tfDistance.text = Int(stepDistance.value).description
    }
    
    func initDates(){
        
        // Formatteurs de date
        self.dateFormatDisplay.dateFormat = "dd/MM/YYYY"
        self.dateFormatAPI.dateFormat = "YYYY-MM-dd"
        
        // DatePickers
        self.pickerDateFrom.datePickerMode = .date
        self.pickerDateFrom.date = Date()
        self.updateDateFrom()
        
        self.pickerDateTo.datePickerMode = .date
        self.pickerDateTo.date = Date().tomorrow
        self.updateDateTo()
        
        
        // Date de début
        self.tfPeriodeStart.delegate = self
        self.tfPeriodeStart.isEnabled = swPeriode.isOn
        self.tfPeriodeStart.isHidden = !swPeriode.isOn
        self.lblPeriodeStart.isHidden = !swPeriode.isOn
        self.tfPeriodeStart.inputView = pickerDateFrom
        
        // Date de fin
        self.tfPeriodeEnd.delegate = self
        self.tfPeriodeEnd.isEnabled = swPeriode.isOn
        self.tfPeriodeEnd.isHidden = !swPeriode.isOn
        self.lblPeriodeEnd.isHidden = !swPeriode.isOn
        self.tfPeriodeEnd.inputView = pickerDateTo
        
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
    
    func searchGroups(){
        let url : String! = Tools.BASE_API_URL + "groupes"
        var params: Parameters = Parameters()
        
        if(self.styleID > 0){
            params.updateValue(self.styleID, forKey: "styles")
        }
        
        if(self.tfAdresse.text != "" && self.tfDistance.text != ""){
            params.updateValue(tfAdresse.text!, forKey: "adresse")
            params.updateValue(Int(self.tfDistance.text!) ?? 0, forKey: "rayon")
        }
        
        LoaderController.sharedInstance.showLoader(text: "Recherche...")
        Alamofire.request(url, method: .get, parameters: params, headers: Tools.getHeaders())
            .responseJSON { response in
                if(response.result.isSuccess){
                    let resultat = response.result.value as! [String:Any]
                    let status = resultat["status"] as! Bool
                    if(status){
                        self.groupesResult = Mapper<Groupe>().mapArray(JSONObject: resultat["groups"])!
                        
                        if(self.groupesResult.isEmpty){
                            // Affichage d'un message d'avertissement pour informer l'utilisateur
                            // qu'aucun groupe n'a été trouvé avec ces paramètres de recherche
                            LoaderController.sharedInstance.removeLoader()
                            let Alerte : UIAlertController = UIAlertController(title: "Pas de résultat", message: "Aucun groupe ne correspond aux critères de recherche que vous avez entré", preferredStyle: .alert)
                            let ActionOK: UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            Alerte.addAction(ActionOK)
                            
                            self.present(Alerte, animated: true)
                        } else {
                            // Affichage du résultat
                            self.performSegue(withIdentifier: "searchGroupSegue", sender: self)
                            LoaderController.sharedInstance.removeLoader()
                        }
                    } else {
                        LoaderController.sharedInstance.removeLoader()
                        print(resultat["message"] as! String)
                    }
                } else {
                    LoaderController.sharedInstance.removeLoader()
                }
        }
    }
    
    func searchEvents(){
        let url : String! = Tools.BASE_API_URL + "evenements"
        var params: Parameters = Parameters()
        
        params.updateValue(1, forKey: "get_ville")
        
        if(self.styleID > 0){
            params.updateValue(self.styleID, forKey: "styles")
        }
        
        if(self.tfAdresse.text != "" && self.tfDistance.text != ""){
            params.updateValue(tfAdresse.text!, forKey: "adresse")
            params.updateValue(Int(self.tfDistance.text!) ?? 0, forKey: "rayon")
        }
        
        if(self.swPeriode.isOn){
            let dateFrom:Date = dateFormatDisplay.date(from: self.tfPeriodeStart.text!)!
            let dateTo:Date = dateFormatDisplay.date(from: self.tfPeriodeEnd.text!)!
            
            params.updateValue(dateFormatAPI.string(from: dateFrom), forKey: "date_du")
            params.updateValue(dateFormatAPI.string(from: dateTo), forKey: "date_au")
        }
        
        LoaderController.sharedInstance.showLoader(text: "Recherche en cours...")
        let response = Alamofire.request(url, method: .get, parameters: params, headers: Tools.getHeaders()).responseJSON()
        LoaderController.sharedInstance.removeLoader()
        
        if (response.result.isSuccess) {
            
            // Récupération du résultat JSON en un tableau associatif
            let result = response.result.value as! [String:Any]
            
            // Récupération et vérification du statut de la requete
            let status = result["status"] as! Bool
            if(status){
                
                // Récupération des évènements dans la réponse
                self.eventsResult = Mapper<Evenement>().mapArray(JSONObject: result["events"])
                
                // Vérification du nombre d'éléments reçus
                if(eventsResult.isEmpty){
                    
                    // Affichage d'un message d'avertissement pour informer l'utilisateur
                    // qu'aucun évènement n'a été trouvé avec ces paramètres de recherche
                    let titre:String = "Pas de résultat"
                    let message:String = "Aucun évènement ne correspond aux critères de recherche que vous avez entré"
                    
                    let alerte : UIAlertController = UIAlertController(title: titre, message: message, preferredStyle: .alert)
                    let actionOK: UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alerte.addAction(actionOK)
                    
                    self.present(alerte, animated: true)
                } else {
                    let segueIdentifier:String = "searchEventSegue"
                    performSegue(withIdentifier: segueIdentifier, sender: self)
                }
            } else {
                print(result["message"] as! String)
            }
        }
    }
    
    func initLocation(){
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        self.lat = userLocation.coordinate.latitude
        self.long = userLocation.coordinate.longitude
    }
    
    func getUserLocation(){
        
        let url : String! = Tools.BASE_API_URL + "localisations"
        let params: Parameters = [
            "type" : 1,
            "lat" : self.lat,
            "lon" : self.long,
        ]
        
        LoaderController.sharedInstance.showLoader()
        
        Alamofire.request(url, method: .get, parameters: params, headers: Tools.getHeaders())
            .responseJSON { response in
                if(response.result.isSuccess){
                    let resultat = response.result.value as! [String:Any]
                    let status = resultat["status"] as! Bool
                    if(status){
                        self.tfAdresse.text = resultat["address"] as? String
                    }
                    
                    LoaderController.sharedInstance.removeLoader()
                } else {
                    LoaderController.sharedInstance.removeLoader()
                }
        }
        
    }
    
    func updateDateFrom (){
        let dateFrom:Date = self.pickerDateFrom.date
        let dateTo:Date = self.pickerDateTo.date
        
        self.tfPeriodeStart.text = self.dateFormatDisplay.string(from: pickerDateFrom.date)
        if(dateFrom > dateTo){
            self.pickerDateTo.date = dateFrom.tomorrow
            updateDateTo()
        }
    }
    
    func updateDateTo (){
        
        let dateFrom:Date = self.pickerDateFrom.date
        let dateTo:Date = self.pickerDateTo.date
        
        self.tfPeriodeEnd.text = self.dateFormatDisplay.string(from: pickerDateTo.date)
        if(dateTo < dateFrom){
            self.pickerDateFrom.date = dateTo.yesterday
            updateDateFrom()
        }
    }
    
    // MARK : - Fonction delegate picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.styles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return styles[row].nom
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.tfStyle.text = styles[row].nom
        self.styleID = styles[row].id_styles
    }
    
    
    
    // MARK : - Fonction surchargée
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch(segue.identifier as String?){
        case "searchGroupSegue":
            let destination = segue.destination as? GroupSearchController
            destination?.groupes = self.groupesResult
            break
            
        case "searchEventSegue":
            let destination = segue.destination as? EventTableViewController
            destination?.events = self.eventsResult
            break
            
        default:
            break
        }
    }
}


