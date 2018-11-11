//
//  Resource.swift
//  ReefLifeTV
//
//  Created by David Sobeski on 11/3/18.
//  Copyright © 2018 David Sobeski. All rights reserved.
//

import Foundation

//
//  The Resource object is use to contain all the constants of all our IDs that are used in our
//  storyboards or NIB files.
//

struct Resource
{
    // ---------------------------------------------------------------------------------------------
    // MARK: - Data Files
    
    static let RLDatabaseName                   = "ReefLife.db"
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Tags and Reusable Identifiers
    
    static let SpeciesCell                      = "speciesCell"
    static let SpeciesImageTag                  = 1000
    static let SpeciesNameTag                   = 1001
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Segue Names
    
    static let SegueSpecieDetails               = "segueSpecieDetails"
    static let SegueProperties                  = "propertiesSegue"
    static let SegueSearchResults               = "searchResultsSegue"
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Storyboard Names
    
    static let StoryboardPhoto                  = "Photo"
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Asset Catalog Names
    
    static let UnknownImage                     = "UnknownImage"
}
