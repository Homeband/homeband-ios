//
//  MembreDao.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 4/06/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit

protocol MembreDao: Dao where K == Int, E == Membre {
    func listByGroup(_ id_groupes:Int) -> [Membre]?
    func deleteByGroup(_ id_groupes:Int)
}
