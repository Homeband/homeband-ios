//
//  GroupViewController.swift
//  HomeBand
//
//  Created on 12/05/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireImage
import AlamofireObjectMapper
import ImageLoader
import Toucan

class GroupViewController: UIViewController {

    @IBOutlet weak var imgGroupe: UIImageView!
    @IBOutlet weak var lbVille: UILabel!
    @IBOutlet weak var lbStyle: UILabel!
    @IBOutlet weak var segInfos: UISegmentedControl!
    @IBOutlet weak var containerInfos: UIView!
    @IBOutlet weak var btnFavorisRond: RadiusButton!
    @IBOutlet weak var btnFavoris: UIButton!
    
    // Variables
    private var user:Utilisateur! = Tools.getConnectedUser()
    private var isFavourite:Bool = false
    
    // Subviews
    private var groupBioView: GroupBioView!
    private var groupMembersView: UIView!
    private var groupContactView: UIView!
    
    // DAO
    private let utilisateurDao = UtilisateurDaoImpl()
    private let evenementDao = EvenementDaoImpl()!
    private let groupeDao = GroupeDaoImpl()!
    private let membreDao = MembreDaoImpl()!
    private let villeDao = VilleDaoImpl()!
    private let styleDao = StyleDaoImpl()!
    private let albumDao = AlbumDaoImpl()!
    private let titreDao = TitreDaoImpl()!
    private let utilisateurGroupeDao = UtilisateurGroupeDaoImpl()!
    
    // Variables publiques
    var events:[Evenement]?
    var albums:[Album]?
    var avis:[Avis]?
    var group:Groupe!
    var members:[Membre]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialisation()
    }
    
    // MARK - Fonctions
    
    private func initialisation(){
        initImage()
        initInfos()
        initContainer()
    }
    
    private func initInfos(){
        
        let ville:Ville? = villeDao.get(key: self.group.id_villes)
        if(ville != nil){
            self.lbVille.text = ville!.nom
        } else {
            self.lbVille.text = ""
        }
        
        let style:Style? = styleDao.get(key: self.group.id_style)
        if(ville != nil){
            self.lbStyle.text = style!.nom
        } else {
            self.lbStyle.text = ""
        }
        
        editIsFavourite(utilisateurDao?.getGroup(id_utilisateurs: self.user.id_utilisateurs, id_group: self.group.id_groupes) != nil)
    }
    
    private func initImage(){
        var urlImg:String = Tools.NO_IMAGE_URL
        
        if(group.illustration != ""){
            urlImg = Tools.BASE_IMAGE_GROUP_URL + group.illustration
        }
        
        let imgWidth = self.imgGroupe.frame.size.width
        let imgHeight = self.imgGroupe.frame.size.height
        
        self.imgGroupe.load.request(with: urlImg, onCompletion: {image, error, operation in
            let imageOK = Toucan(image: image!).resize(CGSize(width: imgWidth, height: imgHeight), fitMode: Toucan.Resize.FitMode.crop).image
            
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionFade
            self.imgGroupe.layer.add(transition, forKey: nil)
            self.imgGroupe.image = imageOK
        })
    }
    
    private func initContainer(){
        self.groupBioView = GroupBioView(group)
        self.groupMembersView = MemberTableViewController(members).view
        self.groupContactView = GroupContactView(group).view
        
        //self.groupBioView.btnFacebook.addTarget(self, action: Selector(("btnFacebookClick")), for: .touchUpInside)
        
        self.containerInfos.addSubview(self.groupBioView.view)
        self.containerInfos.addSubview(self.groupMembersView)
        self.containerInfos.addSubview(self.groupContactView)
        
        self.containerInfos.bringSubview(toFront: self.groupBioView.view)
    }
    
    private func editIsFavourite(_ favourite:Bool){
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
    
    private func addFavourite(){
        // Affichage du loader
        LoaderController.sharedInstance.showLoader()
        
        // Paramètres de l'API
        let url = Tools.BASE_API_URL + "utilisateurs/" + String(user.id_utilisateurs) + "/groupes/" + String(group.id_groupes)
        let params:Parameters = [
            "get_groupe" : 0,
            "get_membres" : 0,
            "get_albums" : 1,
            "get_titres" : 1
        ]
        let headers = Tools.getHeaders()
        
        // Requête à l'API
        Alamofire.request(url, method: .post, parameters: params, headers: headers).responseJSON { response in
            
            if(response.result.isSuccess){
                
                // Récupération du résultat
                let resultat = response.result.value as! [String:Any]
                let status = resultat["status"] as! Bool
                
                // Traitement du résultat
                if(status){
                    // Récupération des éléments reçus
                    let albums:[Album] = Mapper<Album>().mapArray(JSONObject: resultat["albums"])!
                    let titres:[Titre] = Mapper<Titre>().mapArray(JSONObject: resultat["titles"])!
                    
                    // Ajout des éléments
                    //self.groupeDao.write(obj: self.group, update: true)
                    let user = Tools.getConnectedUser()
                    self.utilisateurDao?.addGroup(id_utilisateurs: user!.id_utilisateurs, group: self.group)
                    self.groupeDao.write(obj: Groupe(value: self.group), update: true)
                    
                    for member in self.members {
                        self.membreDao.write(obj: Membre(value: member), update: true)
                    }
                    
                    for album in albums{
                        self.albumDao.write(obj: Album(value: album), update: true)
                    }
                    
                    for titre in titres{
                        self.titreDao.write(obj: Titre(value: titre), update: true)
                    }
                    
                    // Modification de la variable de favoris
                    self.editIsFavourite(true)
                    
                } else {
                    let titre = "Oups !"
                    let msg = "Une erreur s'est produite lors de l'ajout du groupe en favoris.\nVeuillez réessayer plus tard."
                    
                    let alert = UIAlertController(title: titre, message: msg, preferredStyle: .alert)
                    let actionOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alert.addAction(actionOK)
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                let titre = "Oups !"
                let msg = "Une erreur s'est produite lors de l'ajout du groupe en favoris.\nVeuillez réessayer plus tard."
                
                let alert = UIAlertController(title: titre, message: msg, preferredStyle: .alert)
                let actionOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alert.addAction(actionOK)
                self.present(alert, animated: true, completion: nil)
            }
            
            LoaderController.sharedInstance.removeLoader()
        }
    }
    
    private func removeFavourite(){
        // Affichage du loader
        LoaderController.sharedInstance.showLoader()
        
        // Paramètres de l'API
        let url = Tools.BASE_API_URL + "utilisateurs/" + String(user.id_utilisateurs) + "/groupes/" + String(group.id_groupes)
        let headers = Tools.getHeaders()
            
        // Requête à l'API
        Alamofire.request(url, method: .delete, headers: headers).responseJSON { response in
            
            if(response.result.isSuccess){
                
                // Récupération du résultat
                let resultat = response.result.value as! [String:Any]
                let status = resultat["status"] as! Bool
                
                // Traitement du résultat
                if(status){
                    let user = Tools.getConnectedUser()
                    
                    self.utilisateurDao?.deleteGroup(id_utilisateurs: user!.id_utilisateurs, id_groupes: self.group.id_groupes)
                    
                    if(!self.groupeDao.isUsed(key: self.group.id_groupes)){
                        // Suppression des éléments
                        self.titreDao.deleteByGroup(self.group.id_groupes)
                        self.albumDao.deleteByGroup(self.group.id_groupes)
                        self.membreDao.deleteByGroup(self.group.id_groupes)
                    }
                    
                    // Modification de la variable de favoris
                    self.editIsFavourite(false)
                } else {
                    let titre = "Oups !"
                    let msg = "Une erreur s'est produite lors de la suppression du groupe de vos favoris.\nVeuillez réessayer plus tard."
                    
                    let alert = UIAlertController(title: titre, message: msg, preferredStyle: .alert)
                    let actionOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alert.addAction(actionOK)
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                let titre = "Oups !"
                let msg = "Une erreur s'est produite lors de la suppression du groupe de vos favoris.\nVeuillez réessayer plus tard."
                
                let alert = UIAlertController(title: titre, message: msg, preferredStyle: .alert)
                let actionOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alert.addAction(actionOK)
                self.present(alert, animated: true, completion: nil)
            }
            
            LoaderController.sharedInstance.removeLoader()
        }
    }
    
    // MARK - Interactions avec les éléments
    
    @IBAction func segInfosChanged(_ sender: UISegmentedControl) {
        switch segInfos.selectedSegmentIndex {
        case 0:
            self.containerInfos.bringSubview(toFront: self.groupBioView.view)
            break
        case 1:
            self.containerInfos.bringSubview(toFront: self.groupMembersView)
            break
        case 2:
            self.containerInfos.bringSubview(toFront: self.groupContactView)
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
    
    @IBAction func onClickEvents(_ sender: UIButton) {
        
        let url : String! = Tools.BASE_API_URL + "groupes/" + String(self.group.id_groupes) + "/evenements"
        var params: Parameters = Parameters()
        params.updateValue(1, forKey: "get_ville")
        
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
                self.events = Mapper<Evenement>().mapArray(JSONObject: result["events"])
                
                // Vérification du nombre d'éléments reçus
                if(events?.isEmpty)!{
                    
                    // Affichage d'un message d'avertissement pour informer l'utilisateur
                    // qu'aucun évènement n'a été trouvé avec ces paramètres de recherche
                    let titre:String = "Aucun évènement"
                    let message:String = "Il n'y a pas d'évènement disponible pour ce groupe."
                    
                    let alerte : UIAlertController = UIAlertController(title: titre, message: message, preferredStyle: .alert)
                    let actionOK: UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alerte.addAction(actionOK)
                    
                    self.present(alerte, animated: true)
                } else {
                    let segueID = "ShowGroupEvents"
                    performSegue(withIdentifier: segueID, sender: self)
                }
            } else {
                print(result["message"] as! String)
            }
        }
    }
    
    @IBAction func onClickMusique(_ sender: Any) {
        let url : String! = Tools.BASE_API_URL + "groupes/" + String(self.group.id_groupes) + "/albums"
        
        LoaderController.sharedInstance.showLoader(text: "Recherche en cours...")
        let response = Alamofire.request(url, method: .get, headers: Tools.getHeaders()).responseJSON()
        
        LoaderController.sharedInstance.removeLoader()
        
        if (response.result.isSuccess) {
            
            // Récupération du résultat JSON en un tableau associatif
            let result = response.result.value as! [String:Any]
            
            // Récupération et vérification du statut de la requete
            let status = result["status"] as! Bool
            if(status){
                
                // Récupération des albums dans la réponse
                self.albums = Mapper<Album>().mapArray(JSONObject: result["albums"])
                
                // Vérification du nombre d'éléments reçus
                if(albums?.isEmpty)!{
                    
                    // Affichage d'un message d'avertissement pour informer l'utilisateur
                    // qu'aucun évènement n'a été trouvé avec ces paramètres de recherche
                    let titre:String = "Aucun Album"
                    let message:String = "Il n'y a pas d'album disponible pour ce groupe."
                    
                    let alerte : UIAlertController = UIAlertController(title: titre, message: message, preferredStyle: .alert)
                    let actionOK: UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alerte.addAction(actionOK)
                    
                    self.present(alerte, animated: true)
                } else {
                    let segueID = "ShowGroupAlbums"
                    performSegue(withIdentifier: segueID, sender: self)
                }
            } else {
                print(result["message"] as! String)
            }
        }
    }
    
    @IBAction func onClickAvis(_ sender: Any) {
        let url : String! = Tools.BASE_API_URL + "groupes/" + String(self.group.id_groupes) + "/avis"
        
        LoaderController.sharedInstance.showLoader(text: "Recherche en cours...")
        let params:Parameters = [
            "type": 1
        ]
        
        let response = Alamofire.request(url, method: .get,parameters: params, headers: Tools.getHeaders()).responseJSON()
        
        LoaderController.sharedInstance.removeLoader()
        
        if (response.result.isSuccess) {
            
            // Récupération du résultat JSON en un tableau associatif
            let result = response.result.value as! [String:Any]
            
            // Récupération et vérification du statut de la requete
            let status = result["status"] as! Bool
            if(status){
                
                // Récupération des albums dans la réponse
                self.avis = Mapper<Avis>().mapArray(JSONObject: result["comments"])
                
                let segueID = "ShowGroupComments"
                performSegue(withIdentifier: segueID, sender: self)
                
            } else {
                print(result["message"] as! String)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        LoaderController.sharedInstance.showLoader()
        
        let segueID:String? = segue.identifier
        
        switch(segueID){
        case "ShowGroupEvents":
            let destination = segue.destination as? EventTableViewController
            destination?.events = self.events
            
            break
        case "ShowGroupAlbums":
            let destination = segue.destination as? AlbumTableViewController
            destination?.albums = self.albums
            
        case "ShowGroupComments":
            let destination = segue.destination as? AvisTableViewController
            destination?.avis = self.avis
            destination?.id_groupes = self.group.id_groupes
            
        default:
            print("Bad SegueID")
            break
        }
        
        LoaderController.sharedInstance.removeLoader()
    }
    
    func btnFacebookClick(sender:UIButton){
        print("Pression OK")
    }
    
}
