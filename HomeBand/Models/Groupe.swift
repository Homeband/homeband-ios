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

class Groupe : Mappable {
    var id_groupes: Int = 0
    var nom: String = ""
    var login: String = ""
    var mot_de_passe: String = ""
    var email: String = ""
    var biographie: String = ""
    var contacts: String = ""
    var lien_itunes: String = ""
    var lien_youtube: String = ""
    var lien_spotify: String = ""
    var lien_soundcloud: String = ""
    var lien_bandcamp: String = ""
    var lien_twitter: String = ""
    var lien_instagram: String = ""
    var lien_facebook: String = ""
    var est_actif: Bool = false
    var id_style: Int = 0
    var id_villes: Int = 0
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id_groupes <- map["id_groupes"]
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
        est_actif <- map["est_actif"]
        id_style <- map["id_style"]
        id_villes <- map["id_villes"]
    }
}
