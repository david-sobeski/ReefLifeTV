//
//  ReloadDataDelegate.swift
//  ReefLifeTV
//
//  Created by David Sobeski on 11/4/18.
//  Copyright © 2018 David Sobeski. All rights reserved.
//

import Foundation

protocol ReloadDataDelegate {
    func dataChanged()
    func dataChanged(typeId: Int)
    func dataChanged(groupName: String)
    func dataChanged(searchText: String)
}
