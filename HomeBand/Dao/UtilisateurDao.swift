//
//  UtilisateurDao.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 5/06/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit

protocol UtilisateurDao: Dao where K == Int, E == Utilisateur {
    func addGroup(id_utilisateurs:Int, group:Groupe)
    func deleteGroup(id_utilisateurs:Int, id_groupes:Int)
    func getGroup(id_utilisateurs:Int, id_group:Int) -> Groupe?
    func listGroups(id_utilisateurs:Int) -> [Groupe]?
    func addEvent(id_utilisateurs:Int, event:Evenement)
    func deleteEvent(id_utilisateurs:Int, id_evenements:Int)
    func getEvent(id_utilisateurs:Int, id_evenements:Int) -> Evenement?
    func listEvents(id_utilisateurs:Int) -> [Evenement]?
}
