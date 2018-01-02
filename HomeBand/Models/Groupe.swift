//
//  Groupe.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 29/11/17.
//  Copyright © 2017 HEH. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper
import RealmSwift

class Groupe : Object,Mappable {
  @objc dynamic var id_groupes: Int = 0
  @objc dynamic var nom: String = ""
  @objc dynamic var login: String = ""
  @objc dynamic var mot_de_passe: String = ""
  @objc dynamic var email: String = ""
  @objc dynamic var biographie: String = ""
  @objc dynamic var contacts: String = ""
  @objc dynamic var lien_itunes: String = ""
  @objc dynamic var lien_youtube: String = ""
  @objc dynamic var lien_spotify: String = ""
  @objc dynamic var lien_soundcloud: String = ""
  @objc dynamic var lien_bandcamp: String = ""
  @objc dynamic var lien_twitter: String = ""
  @objc dynamic var lien_instagram: String = ""
  @objc dynamic var lien_facebook: String = ""
  @objc dynamic var est_actif: Bool = false
  @objc dynamic var id_style: Int = 0
  @objc dynamic var id_villes: Int = 0
  @objc dynamic var api_ck: String = ""
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        id_groupes <- (map["id_groupes"], IntTransform())
        nom <- map["nom"]
        login <- map["login"]
        mot_de_passe <- map["mot_de_passe"]
        email <- map["email"]
        biographie <- map["biographie"]
        contacts <- map["contacts"]
        lien_itunes <- map["lien_itunes"]
        lien_youtube <- map["lien_youtube"]
        lien_spotify <- map["lien_spotify"]
        lien_soundcloud <- map["lien_soundcloud"]
        lien_bandcamp <- map["lien_bandcamp"]
        lien_twitter <- map["lien_twitter"]
        lien_instagram <- map["lien_instagram"]
        lien_facebook <- map["lien_facebook"]
        est_actif <- (map["est_actif"], BooleanTransform())
        id_style <- (map["id_style"], IntTransform())
        id_villes <- (map["id_villes"], IntTransform())
        api_ck <- map["api_ck"]
    }
}
