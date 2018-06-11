//
//  VersionDao.swift
//  HomeBand
//
//  Created on 1/05/18.
//  Copyright © 2018 HEH. All rights reserved.
//

protocol VersionDao: Dao where K == Int, E == Version {
    func getByNomTable(nom_table:String) -> Version?
}
