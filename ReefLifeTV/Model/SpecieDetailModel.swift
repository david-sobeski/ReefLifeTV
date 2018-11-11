//
//  SpecieDetailModel.swift
//  ReefLifeTV
//
//  Created by David Sobeski on 11/3/18.
//  Copyright © 2018 David Sobeski. All rights reserved.
//

import Foundation

//
//  This object represents a fully filled out specie where all ids are expanded to their correct
//  equivalents.
//
struct SpecieDetailModel
{
    var id: Int                         = -1
    var commonName: String              = ""
    var commonNameES: String            = ""
    var commonNameFR: String            = ""
    var commonNameDE: String            = ""
    var specie: String                  = ""
    var maxSize: String                 = ""
    var regions: String                 = ""
    var details: String                 = ""
    var detailsCreditSource: String     = ""
    var detailsCreditLink: String       = ""
    var detailsCreditDate: String       = ""
    var genus: String                   = ""
    var family: String                  = ""
    var order: String                   = ""
    var iucnClassification: String      = ""
    var group: String                   = ""
    var type: String                    = ""
    
    //
    //  This method will return a JSON representation of our SpecieDetailModel.
    //
    func toJSON() -> String?
    {
        //
        //  Dictionary of our properties that we want to convert to JSON.
        //
        let properties = [
            "id":                   self.id,
            "commonName":           self.commonName,
            "commonNameES":         self.commonNameES,
            "commonNameFR":         self.commonNameFR,
            "commonNameDE":         self.commonNameDE,
            "specie":               self.specie,
            "maxSize":              self.maxSize,
            "regions":              self.regions,
            "details":              self.details,
            "detailsCreditSource":  self.detailsCreditSource,
            "detailsCreditLink":    self.detailsCreditLink,
            "detailsCreditDate":    self.detailsCreditDate,
            "genus":                self.genus,
            "family":               self.family,
            "order":                self.order,
            "iucnClassification":   self.iucnClassification,
            "group":                self.group,
            "type":                 self.type
            ] as [String : Any]
        
        //
        //  We serialize our JSON data and return it as a pretty printed JSON string. If we could
        //  not create the JSON string, then we return nil.
        //
        do
        {
            let jsonData = try JSONSerialization.data(withJSONObject: properties, options: JSONSerialization.WritingOptions(rawValue: 0))
            return String(data: jsonData, encoding: String.Encoding.utf8)
        }
        catch
        {
            return nil
        }
    }
}
