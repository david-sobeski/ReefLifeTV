//
//  String+Extension.swift
//  ReefLifeTV
//
//  Created by David Sobeski on 11/3/18.
//  Copyright © 2018 David Sobeski. All rights reserved.
//

import Foundation

//
//  We create a simple extension to the String class to make it easier to convert to localized
//  languages.
//
extension String
{
    //
    //  We add a localized property to the String class to return the localize string for a
    //  particular string. If it doesn't have an equivalent, the base "English" version is
    //  returned.
    //
    var localized: String
    {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
