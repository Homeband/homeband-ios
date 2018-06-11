//
//  UtilisateurGroupeDao.swift
//  HomeBand
//
//  Created on 4/06/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit

protocol UtilisateurGroupeDao: Dao where K == (id_utilisateurs:Int,  id_groupes:Int), E == UtilisateurGroupe {
    
}
