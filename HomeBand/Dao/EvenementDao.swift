//
//  EvenementDao.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 4/06/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit

protocol EvenementDao: Dao where K == Int, E == Evenement {
    func listByUser(id_utilisateurs:Int) -> [Evenement]?
    func listByGroup(id_groupes:Int) -> [Evenement]?
    func isUsed(key:Int) -> Bool
}
