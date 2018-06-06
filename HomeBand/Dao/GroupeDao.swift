//
//  GroupeDAO.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 1/05/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit

protocol GroupeDao : Dao where K == Int, E == Groupe {
    func listByUser(id_utilisateurs:Int) -> [Groupe]?
    func isUsed(key:Int) -> Bool
}
