//
//  TitreDao.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 4/06/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit

protocol TitreDao: Dao where K == Int, E == Titre {
    func listByGroup(_ id_groupes:Int) -> [Titre]?
    func deleteByGroup(_ id_groupes:Int)
}
