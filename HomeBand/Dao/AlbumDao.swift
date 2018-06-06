//
//  AlbumDao.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 4/06/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import UIKit

protocol AlbumDao: Dao  where K == Int, E == Album {
    func listByGroup(_ id_groupes:Int) -> [Album]?
    func deleteByGroup(_ id_groupes:Int)
}
