//
//  EventViewController.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 27/05/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit
import EventKit

class EventViewController: UIViewController {
    
    var isLocal:Bool! = false
    
    var event:Evenement!
    var address:Adresse!
    var group:Groupe!
    var ville:Ville!
    var isFavourite:Bool = false
    
    var utilisateurDao = UtilisateurDaoImpl()!
    var evenementDao = EvenementDaoImpl()!
    var groupeDao = GroupeDaoImpl()!
    var adresseDao = AdresseDaoImpl()!
    var villeDao = VilleDaoImpl()!
    
    @IBOutlet weak var imgIllustration: UIImageView!
    @IBOutlet weak var segInfos: UISegmentedControl!
    @IBOutlet weak var containerSubviews: UIView!
    @IBOutlet weak var btnFavorisRond: RadiusButton!
    @IBOutlet weak var btnFavoris: UIButton!
    
    private var eventInfoView:UIView!
    private var eventDescriptionView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialisation()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initContainter(){
        self.eventInfoView = EventInformationsViewController(event: self.event, address: self.address, group: self.group).view
        self.eventDescriptionView = EventDescriptionViewController(self.event).view
        
        self.containerSubviews.addSubview(self.eventDescriptionView)
        self.containerSubviews.addSubview(self.eventInfoView)
        self.containerSubviews.bringSubview(toFront: self.eventDescriptionView)
    }
    
    func initialisation(){
        self.title = self.event.nom
        initContainter()
        
        let user = Tools.getConnectedUser()
        editIsFavourite(utilisateurDao.getEvent(id_utilisateurs: user!.id_utilisateurs, id_evenements: self.event.id_evenements) != nil)
        
        self.ville = villeDao.get(key: self.address.id_villes)
    }
    
    func editIsFavourite(_ favourite:Bool){
        isFavourite = favourite
        
        if(isFavourite){
            // Modifications de l'apparences des boutons favoris
            self.btnFavorisRond.backgroundColor = UIColor.hbFavourite
            self.btnFavoris.setTitleColor(UIColor.hbFavourite, for: .normal)
            self.btnFavoris.setTitle("Favoris !", for: .normal)
        } else {
            // Modifications de l'apparences des boutons favoris
            self.btnFavorisRond.backgroundColor = UIColor.hbInactive
            self.btnFavoris.setTitleColor(UIColor.hbInactive, for: .normal)
            self.btnFavoris.setTitle("Ajouter en favoris", for: .normal)
        }
    }
    
    func addFavourite(){
        // Ajout des éléments
        let user = Tools.getConnectedUser()
        self.utilisateurDao.addEvent(id_utilisateurs: user!.id_utilisateurs, event: self.event)
        
        adresseDao.write(obj: Adresse(value: self.address), update: true)
        
        if(groupeDao.get(key: self.group.id_groupes) == nil){
            groupeDao.write(obj: Groupe(value: self.group), update: true)
        }
        
        // Mise à jour du boutons de favoris
        editIsFavourite(true)
    }
    
    func removeFavourite(){
        let user = Tools.getConnectedUser()
        self.utilisateurDao.deleteEvent(id_utilisateurs: user!.id_utilisateurs, id_evenements: self.event.id_evenements)
        
        if(!self.evenementDao.isUsed(key: self.event.id_evenements)){
            // Suppression des éléments
            self.adresseDao.delete(key: self.address.id_adresses)
            
            if(!self.groupeDao.isUsed(key: self.group.id_groupes)){
                self.groupeDao.delete(key: self.group.id_groupes)
            }
        }
        
        // Mise à jour du boutons de favoris
        editIsFavourite(false)
    }

    
    // MARK - Interactions avec les éléments
    @IBAction func segInfosChanged(_ sender: Any) {
        switch segInfos.selectedSegmentIndex {
        case 0:
            self.containerSubviews.bringSubview(toFront: self.eventDescriptionView)
            break
        case 1:
            self.containerSubviews.bringSubview(toFront: self.eventInfoView)
            break
        default:
            break
        }
    }
    
    @IBAction func onClickFavoris(_ sender: Any) {
        if(isFavourite == false){
            addFavourite()
        } else {
            removeFavourite()
        }
    }

    @IBAction func onClickAddCalendar(_ sender: Any) {
        
        let eventStore:EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: EKEntityType.event, completion:
            {(granted, error) in
                if granted {
                    let eventCalendar:EKCalendar = eventStore.defaultCalendarForNewEvents!
                    let eventNew:EKEvent = EKEvent(eventStore: eventStore)
                    
                    let villeTxt = ", " + self.ville!.code_postal + " " + self.ville!.nom
                    let adresseComplete:String = String(self.address.numero) + " " + self.address.rue.capitalizingFirstLetter() + villeTxt
                    
                    eventNew.title = self.event.nom
                    eventNew.startDate = self.event.date_heure
                    eventNew.endDate = self.event.date_heure.addingTimeInterval(2.0 * 60.0 * 60.0)
                    eventNew.location = adresseComplete
                    eventNew.calendar = eventCalendar
                    
                    do{
                        try eventStore.save(eventNew, span: .thisEvent)
                        let alert = UIAlertController(title: "Évènement ajouté !", message: "L'évènement a été ajouté à votre calendrier.", preferredStyle: .alert)
                        let actionOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alert.addAction(actionOK)
                        self.present(alert, animated: true, completion: nil)
                    } catch let error {
                        print(error)
                    }
                }
        })
        
        
        
    }
}
