//
//  RLDatabase.swift
//  ReefLifeTV
//
//  Created by David Sobeski on 11/3/18.
//  Copyright © 2018 David Sobeski. All rights reserved.
//

import Foundation

//
//  The RLDatabase is a reference to our SQLite database. It is used to open and close the database
//  and to issue queries against the database.
//
class RLDatabase
{
    // ---------------------------------------------------------------------------------------------
    // MARK: - Singleton Definition
    
    static let shared = RLDatabase()
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Public Constants
    
    static let Invalid: Int = -1
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Internal Properties
    
    fileprivate var database: OpaquePointer? = nil
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Object Initialization/Deinitialization
    
    //
    //  We have been initialized by the creation of an instance of this object.
    //
    init()
    {
        //
        //  When we are created, we want to open our SQLite database and cache a reference
        //  to the database so it can be used internally.
        //
        
        let databasePath = Bundle.main.path(forResource: Resource.RLDatabaseName, ofType: Strings.EmptyString)
        
        //
        //  We successfully have a path, now try to open the database. If something bad happens
        //  the the SQLITE engine and we do not receive a SQLITE_OK, then dispaly an error and
        //  return false.
        //
        if sqlite3_open(databasePath!, &self.database) != SQLITE_OK
        {
            //
            //  We failed at opening the database, return false.
            //
            print("failed to open database")
        }
    }
    
    //
    //  The object has been freed from memory and we need to "clean-up" and deinitialize.
    //
    deinit
    {
        //
        //  Our object is no longer needed and we need to free any memory or close resources. In
        //  our case, we need to close our SQLite database.
        //
        sqlite3_close(self.database)
    }
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Queries
    
    //
    //  This function querys our RL_Types table and returns an array of Type objects.
    //
    func getTypes() -> Array<Type>
    {
        //
        //  An array of type objects for each of the types that we have found.
        //
        var types: Array<Type> = [Type]()
        
        //
        //  If we do not have an open database, then we must return as we can not do anything
        //  with our database.
        //
        if self.database == nil {
            return types
        }
        
        //
        //  Create an instance of our statement for SQLite to use. And create a temporary Type
        //  object that we will set during each iteration and add to an array of types.
        //
        var statement: OpaquePointer? = nil
        var type: Type =  Type()
        
        //
        //  Run the SQL Query.
        //
        sqlite3_prepare_v2(self.database, SQL.SelectTypes, -1, &statement, nil)
        while sqlite3_step(statement) == SQLITE_ROW
        {
            //
            //  Column 0 contains our ID.
            //
            type.id = Int(sqlite3_column_int64(statement, 0))
            
            //
            //  Column 1 is a string, we need to convert.
            //
            type.name = String(cString: sqlite3_column_text(statement, 1))
            
            //
            //  Add the type to our array of Types.
            //
            types.append(type)
        }
        sqlite3_finalize(statement)
        
        //
        //  Return a list of all the types we found.
        //
        return types
    }
    
    //
    //  This function queries our RL_Groups table and returns a list of Group objects.
    //
    func getGroups() -> Array<Group>
    {
        //
        //  Return a list of all the groups we found.
        //
        return self.getGroups(SQL.SelectGroups)
    }
    
    //
    //  This function queries our RL_Groups table and returns a list of Group objects sorted in
    //  alphabetical order.
    //
    func getGroupsAlphabetical() -> Array<Group>
    {
        //
        //  Return a list of all the groups we found.
        //
        return self.getGroups(SQL.SelectGroupsAlphabetical)
    }
    
    //
    //  The method returns the total number of RL_Types rows that we have store in our table.
    //
    func getTypessCount() -> Int
    {
        return self.getCount(SQL.TypesCount)
    }
    
    //
    //  The method returns the total number of RL_Groups rows that we have store in our table.
    //
    func getGroupsCount() -> Int
    {
        return self.getCount(SQL.GroupsCount)
    }
    
    //
    //  This method return the number of items in our group based on a type id.
    //
    func getGroupsCountByType(_ typeId: Int) -> Int
    {
        return self.getCount(String(format:SQL.GroupsCountByTypeId, typeId))
    }
    
    //
    //  This method returns the number of items in our group based on a type name.
    //
    func getGroupsCountByType(_ typeName: String) -> Int
    {
        return self.getCount(String(format:SQL.GroupsCountByTypeName, typeName))
    }
    
    //
    //  Retrieve the total number of species we have in our database.
    //
    func getSpeciesCount() -> Int
    {
        return self.getCount(SQL.SpeciesCount)
    }
    
    //
    //  Retrieves the count of species based on a group id.
    //
    func getSpecieCountByGroupdId(_ groupId: Int) -> Int {
        return self.getCount(String(format:  SQL.SpecieCountByGroupdId, groupId))
    }
    
    //
    //  Retrieves the count of species for a given type id.
    //
    func getSpecieCountByTypeId(_ typeId: Int) -> Int {
        return self.getCount(String(format:  SQL.SpecieCountByTypeId, typeId))
    }
    
    //
    //  Given a group name, this method will retrieve the type name.
    //
    func getTypeNameForGroupName(_ groupName: String) -> String
    {
        //
        //  Create a type name that we will use to return from this function.
        //
        var typeName: String = Strings.EmptyString
        
        //
        //  If we do not have an open database, then we must return as we can not do anything
        //  with our database.
        //
        if self.database == nil {
            return typeName
        }
        
        //
        //  Create an instance of our statement for SQLite to use. And create a temporary Group
        //  object that we will set during each iteration and add to an array of groups.
        //
        var statement: OpaquePointer? = nil
        
        //
        //  Run the SQL Query.
        //
        let query:String = String(format:SQL.SelectTypeNameForGroupName, groupName)
        sqlite3_prepare_v2(self.database, query, -1, &statement, nil)
        while sqlite3_step(statement) == SQLITE_ROW
        {
            typeName = String(cString: sqlite3_column_text(statement, 0))
        }
        sqlite3_finalize(statement)
        
        //
        //  Return a list of type names.
        //
        return typeName
    }
    
    //
    //  Given a type by its ID, this will fetch a list of all Group names for that type.
    //
    func getGroupNamesForType(_ typeId: Int) -> Array<String>
    {
        //
        //  Return a list of all the groups we found.
        //
        return self.getGroupNamesForType(query: String(format:SQL.SelectGroupNamesForTypeId, typeId))
    }
    
    //
    //  Given a type by its name, this will fetch a list of all Group names for that textual name.
    //
    func getGroupNamesForType(_ typeName: String) -> Array<String>
    {
        //
        //  Return a list of all the groups we found.
        //
        return self.getGroupNamesForType(query: String(format:SQL.SelectGroupNamesForTypeName, typeName))
        
    }
    
    //
    //  This method will return a list of all the photos for a particular species.
    //
    func getSpeciePhotos(_ specieId: Int) -> Array<SpeciePhotoModel>
    {
        //
        //  An array of photo objects for each of the species that we have found.
        //
        var speciePhotos: Array<SpeciePhotoModel> = [SpeciePhotoModel]()
        
        //
        //  If we do not have an open database, then we must return as we can not do anything
        //  with our database.
        //
        if self.database == nil {
            return speciePhotos
        }
        
        //
        //  Create an instance of our statement for SQLite to use. And create a temporary SpecieSimpleModel
        //  object that we will set during each iteration and add to an array of SpecieSimpleModel.
        //
        var statement: OpaquePointer? = nil
        var speciePhoto: SpeciePhotoModel =  SpeciePhotoModel()
        
        //
        //  Run the SQL Query.
        //
        let query:String = String(format:SQL.SelectSpeciePhotos, specieId)
        sqlite3_prepare_v2(self.database, query, -1, &statement, nil)
        while sqlite3_step(statement) == SQLITE_ROW
        {
            speciePhoto.id          = Int(sqlite3_column_int64(statement, 0))
            speciePhoto.name        = String(cString: sqlite3_column_text(statement, 1))
            speciePhoto.credit      = String(cString: sqlite3_column_text(statement, 2))
            speciePhoto.copyright   = String(cString: sqlite3_column_text(statement, 3))
            
            //
            //  Add the contents of Strings.full and we have to go in reverse, hence the - (minus) in
            //  the adancedBy by the number of characters in the JPG extension.
            //
            if speciePhoto.name.isEmpty != true
            {
                let offset = speciePhoto.name.index(speciePhoto.name.endIndex, offsetBy: -Strings.JPGExtension.count)
                speciePhoto.name.insert(contentsOf: Strings.Full, at: offset)
            }
            
            //
            //  Add the specie photo to our array of photos.
            //
            speciePhotos.append(speciePhoto)
        }
        sqlite3_finalize(statement)
        
        //
        //  Return a list of all the species photos we found.
        //
        return speciePhotos
    }
    
    //
    //  This function retrieves an array of group names.
    //
    func getGroupNamesForType(query: String) -> Array<String>
    {
        //
        //  An array of group objects for each of the groups that we have found.
        //
        var groupNames: Array<String> = [String]()
        
        //
        //  If we do not have an open database, then we must return as we can not do anything
        //  with our database.
        //
        if self.database == nil {
            return groupNames
        }
        
        //
        //  Create an instance of our statement for SQLite to use. And create a temporary Group
        //  object that we will set during each iteration and add to an array of groups.
        //
        var statement: OpaquePointer? = nil
        var group: String =  ""
        
        //
        //  Run the SQL Query.
        //
        sqlite3_prepare_v2(self.database, query, -1, &statement, nil)
        while sqlite3_step(statement) == SQLITE_ROW
        {
            group = String(cString: sqlite3_column_text(statement, 0))
            
            //
            //  Add the group to our array of groups.
            //
            groupNames.append(group)
        }
        sqlite3_finalize(statement)
        
        //
        //  Return a list of all the groups we found.
        //
        return groupNames
    }
    
    //
    //  This method returns the id of the type in RL_Types given a name.
    //
    func getTypeIdFromName(_ typeName: String) -> Int
    {
        var id: Int = RLDatabase.Invalid
        
        //
        //  If we do not have an open database, then we must return as we can not do anything
        //  with our database.
        //
        if self.database == nil {
            return id
        }
        
        //
        //  Issue our query to get the count.
        //
        var statement: OpaquePointer? = nil
        
        //
        //  Run the SQL Query.
        //
        let query:String = String(format:SQL.SelectTypeIdFromName, typeName)
        sqlite3_prepare_v2(self.database, query, -1, &statement, nil)
        while sqlite3_step(statement) == SQLITE_ROW
        {
            id = Int(sqlite3_column_int64(statement, 0))
        }
        sqlite3_finalize(statement)
        
        //
        //  Return the number of items we found.
        //
        return id
    }
    
    //
    //  This will retrieve full species detail for a given specie id.
    //
    func getSpecieDetail(_ specieId: Int) -> SpecieDetailModel
    {
        //
        //  Create a temporary SpecieDetailModel for storing our values from the query.
        //
        var specieDetail: SpecieDetailModel = SpecieDetailModel()
        
        //
        //  If we do not have an open database, then we must return as we can not do anything
        //  with our database.
        //
        if self.database == nil {
            return specieDetail
        }
        
        //
        //  Create an instance of our statement for SQLite to use.
        //
        var statement: OpaquePointer? = nil
        
        //
        //  Run the SQL Query.
        //
        let query:String = String(format:SQL.SelectSpecieDetail, specieId)
        sqlite3_prepare_v2(self.database, query, -1, &statement, nil)
        while sqlite3_step(statement) == SQLITE_ROW
        {
            specieDetail.commonName             = String(cString: sqlite3_column_text(statement, 0))
            specieDetail.commonNameFR           = String(cString: sqlite3_column_text(statement, 1))
            specieDetail.commonNameES           = String(cString: sqlite3_column_text(statement, 2))
            specieDetail.commonNameDE           = String(cString: sqlite3_column_text(statement, 3))
            specieDetail.specie                 = String(cString: sqlite3_column_text(statement, 4))
            specieDetail.maxSize                = String(cString: sqlite3_column_text(statement, 5))
            specieDetail.regions                = String(cString: sqlite3_column_text(statement, 6))
            specieDetail.details                = String(cString: sqlite3_column_text(statement, 7))
            specieDetail.detailsCreditSource    = String(cString: sqlite3_column_text(statement, 8))
            specieDetail.detailsCreditLink      = String(cString: sqlite3_column_text(statement, 9))
            specieDetail.detailsCreditDate      = String(cString: sqlite3_column_text(statement, 10))
            specieDetail.genus                  = String(cString: sqlite3_column_text(statement, 11))
            specieDetail.family                 = String(cString: sqlite3_column_text(statement, 12))
            specieDetail.order                  = String(cString: sqlite3_column_text(statement, 13))
            specieDetail.iucnClassification     = String(cString: sqlite3_column_text(statement, 14))
            specieDetail.group                  = String(cString: sqlite3_column_text(statement, 15))
            specieDetail.type                   = String(cString: sqlite3_column_text(statement, 16))
        }
        sqlite3_finalize(statement)
        
        //
        //  Return the details of the specie that we found.
        //
        return specieDetail
    }
    
    //
    //  This method is used to retrieve a single Specie from its id. It returns a single instance
    //  of SpecieSimpleModel.
    //
    func getSecieSimple(_ specieId: Int) -> SpecieSimpleModel
    {
        var specie: SpecieSimpleModel =  SpecieSimpleModel()
        
        //
        //  If we do not have an open database, then we must return as we can not do anything
        //  with our database.
        //
        if self.database == nil {
            return specie
        }
        
        //
        //  Create an instance of our statement for SQLite to use. And create a temporary SpecieSimpleModel
        //  object that we will set during each iteration and add to an array of SpecieSimpleModel.
        //
        var statement: OpaquePointer? = nil
        specie.id = specieId
        
        //
        //  Run the SQL Query.
        //
        let query:String = String(format:SQL.SelectSpecieSimple, specieId)
        sqlite3_prepare_v2(self.database, query, -1, &statement, nil)
        while sqlite3_step(statement) == SQLITE_ROW
        {
            //
            //  Column 0 is our specie (name), not to be confused with common name.
            //
            specie.commonName = String(cString: sqlite3_column_text(statement, 0))
            
            //
            //  Column 1 is our specie (name), not to be confused with common name.
            //
            specie.specie = String(cString: sqlite3_column_text(statement, 1))
            
            //
            //  Column 2 is our family name.
            //
            specie.family = String(cString: sqlite3_column_text(statement, 2))
            
            //
            //  Column 3 is our genus name.
            //
            specie.genus = String(cString: sqlite3_column_text(statement, 3))
        }
        sqlite3_finalize(statement)
        
        //
        //  Return a list of all the species we found.
        //
        return specie
    }
    
    //
    //  Will retrieve all the simple Speices rows from the database.
    //
    func getSpeciesSimple() -> Array<SpecieSimpleModel>
    {
        //
        //  Return a list of all the species we found.
        //
        return self.getSpeciesSimple(SQL.SelectSpeciesSimple)
    }
    
    //
    //  We want all of our simple rows, however, we want to filter it by a group string.
    //
    func getSpeciesSimpleByGroup(_ group: String) -> Array<SpecieSimpleModel>
    {
        let query:String = String(format:SQL.SelectSpeciesSimpleByFilter, group)
        return self.getSpeciesSimple(query)
    }
    
    //
    //  Return our simple version of our species based on their type.
    //
    func getSpeciesSimpleByType(_ typeId: Int) -> Array<SpecieSimpleModel>
    {
        let query:String = String(format:SQL.SelectSpeciesSimpleByType, typeId)
        return self.getSpeciesSimple(query)
    }
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Internal Methods
    
    //
    //  The method returns the total number of RL_Types rows that we have store in our table.
    //
    fileprivate func getCount(_ query: String) -> Int
    {
        var count: Int = 0
        
        //
        //  If we do not have an open database, then we must return as we can not do anything
        //  with our database.
        //
        if self.database == nil {
            return count
        }
        
        //
        //  Issue our query to get the count.
        //
        var statement: OpaquePointer? = nil
        
        //
        //  Run the SQL Query.
        //
        sqlite3_prepare_v2(self.database, query, -1, &statement, nil)
        while sqlite3_step(statement) == SQLITE_ROW
        {
            count = Int(sqlite3_column_int64(statement, 0))
        }
        sqlite3_finalize(statement)
        
        //
        //  Return the number of items we found.
        //
        return count
    }
    
    //
    //  This function queries our RL_Groups table and returns a list of Group objects.
    //
    fileprivate func getGroups(_ query: String) -> Array<Group>
    {
        //
        //  An array of group objects for each of the groups that we have found.
        //
        var groups: Array<Group> = [Group]()
        
        //
        //  If we do not have an open database, then we must return as we can not do anything
        //  with our database.
        //
        if self.database == nil {
            return groups
        }
        
        //
        //  Create an instance of our statement for SQLite to use. And create a temporary Group
        //  object that we will set during each iteration and add to an array of groups.
        //
        var statement: OpaquePointer? = nil
        var group: Group =  Group()
        
        //
        //  Run the SQL Query.
        //
        sqlite3_prepare_v2(self.database, query, -1, &statement, nil)
        while sqlite3_step(statement) == SQLITE_ROW
        {
            //
            //  Column 0 contains our ID.
            //
            group.id = Int(sqlite3_column_int64(statement, 0))
            
            //
            //  Column 1 is a string, we need to convert.
            //
            group.name = String(cString: sqlite3_column_text(statement, 1))
            
            //
            //  Column 2 is our Type ID.
            //
            group.typeId = Int(sqlite3_column_int64(statement, 2))
            
            //
            //  Add the group to our array of groups.
            //
            groups.append(group)
        }
        sqlite3_finalize(statement)
        
        //
        //  Return a list of all the groups we found.
        //
        return groups
    }
    
    //
    //  Will retrieve the simple Speices rows from the database based on our query.
    //
    fileprivate func getSpeciesSimple(_ query: String) -> Array<SpecieSimpleModel>
    {
        //
        //  An array of group objects for each of the species that we have found.
        //
        var species: Array<SpecieSimpleModel> = [SpecieSimpleModel]()
        
        //
        //  If we do not have an open database, then we must return as we can not do anything
        //  with our database.
        //
        if self.database == nil {
            return species
        }
        
        //
        //  Create an instance of our statement for SQLite to use. And create a temporary SpecieSimpleModel
        //  object that we will set during each iteration and add to an array of SpecieSimpleModel.
        //
        var statement: OpaquePointer? = nil
        var specie: SpecieSimpleModel =  SpecieSimpleModel()
        
        //
        //  Run the SQL Query.
        //
        sqlite3_prepare_v2(self.database, query, -1, &statement, nil)
        while sqlite3_step(statement) == SQLITE_ROW
        {
            //
            //  Column 0 contains our ID.
            //
            specie.id = Int(sqlite3_column_int64(statement, 0))
            
            //
            //  Column 1 is our name, not to be confused with specie name.
            //
            specie.commonName = String(cString: sqlite3_column_text(statement, 1))
            
            //
            //  Column 2 is our specie (name), not to be confused with common name.
            //
            specie.specie = String(cString: sqlite3_column_text(statement, 2))
            
            //
            //  Column 3 is our family name.
            //
            specie.family = String(cString: sqlite3_column_text(statement, 3))
            
            //
            //  Column 4 is our genus name.
            //
            specie.genus = String(cString: sqlite3_column_text(statement, 4))
            
            //
            //  Add the group to our array of species.
            //
            species.append(specie)
        }
        sqlite3_finalize(statement)
        
        //
        //  Return a list of all the species we found.
        //
        return species
    }
    
    //
    //  This will retrieve full species detail for a given specie id.
    //
    func searchSpecies(_ searchText: String) -> Array<SpecieDetailModel>
    {
        //
        //  Create a temporary array SpecieDetailModel for storing our values from the query.
        //
        var specieDetails: Array<SpecieDetailModel> = [SpecieDetailModel]()
        
        //
        //  If we do not have an open database, then we must return as we can not do anything
        //  with our database.
        //
        if self.database == nil {
            return specieDetails
        }
        
        //
        //  Create an instance of our statement for SQLite to use.
        //
        var statement: OpaquePointer? = nil
        
        //
        //  We need to find the @ in the query string and replace it with our search text. In the
        //  searchText, we need to replace all the spaces with a %.
        //
        let searchQueryText = searchText.replacingOccurrences(of: " ", with: "%", options: NSString.CompareOptions.literal, range: nil)
        let query = SQL.SearchSpecies.replacingOccurrences(of: "@", with: searchQueryText, options: NSString.CompareOptions.literal, range: nil)
        
        //
        //  Run the SQL Query.
        //
        sqlite3_prepare_v2(self.database, query, -1, &statement, nil)
        while sqlite3_step(statement) == SQLITE_ROW
        {
            var specieDetail: SpecieDetailModel = SpecieDetailModel()
            
            specieDetail.id                     = Int(sqlite3_column_int64(statement, 0))
            specieDetail.commonName             = String(cString: sqlite3_column_text(statement, 1))
            specieDetail.commonNameFR           = String(cString: sqlite3_column_text(statement, 2))
            specieDetail.commonNameES           = String(cString: sqlite3_column_text(statement, 3))
            specieDetail.commonNameDE           = String(cString: sqlite3_column_text(statement, 4))
            specieDetail.specie                 = String(cString: sqlite3_column_text(statement, 5))
            specieDetail.maxSize                = String(cString: sqlite3_column_text(statement, 6))
            specieDetail.regions                = String(cString: sqlite3_column_text(statement, 7))
            specieDetail.details                = String(cString: sqlite3_column_text(statement, 8))
            specieDetail.detailsCreditSource    = String(cString: sqlite3_column_text(statement, 9))
            specieDetail.detailsCreditLink      = String(cString: sqlite3_column_text(statement, 10))
            specieDetail.detailsCreditDate      = String(cString: sqlite3_column_text(statement, 11))
            specieDetail.genus                  = String(cString: sqlite3_column_text(statement, 12))
            specieDetail.family                 = String(cString: sqlite3_column_text(statement, 13))
            specieDetail.order                  = String(cString: sqlite3_column_text(statement, 14))
            specieDetail.iucnClassification     = String(cString: sqlite3_column_text(statement, 15))
            specieDetail.group                  = String(cString: sqlite3_column_text(statement, 16))
            specieDetail.type                   = String(cString: sqlite3_column_text(statement, 17))
            
            specieDetails.append(specieDetail)
        }
        sqlite3_finalize(statement)
        
        //
        //  Return the details of the specie that we found.
        //
        return specieDetails
    }
    
    //
    //  This will retrieve full species simple model for a given specie id.
    //
    func searchSpecies(_ searchText: String) -> Array<SpecieSimpleModel>
    {
        //
        //  Create a temporary array SpecieSimpleModel for storing our values from the query.
        //
        var specieDetails: Array<SpecieSimpleModel> = [SpecieSimpleModel]()
        
        //
        //  If we do not have an open database, then we must return as we can not do anything
        //  with our database.
        //
        if self.database == nil {
            return specieDetails
        }
        
        //
        //  Create an instance of our statement for SQLite to use.
        //
        var statement: OpaquePointer? = nil
        
        //
        //  We need to find the @ in the query string and replace it with our search text. In the
        //  searchText, we need to replace all the spaces with a %.
        //
        let searchQueryText = searchText.replacingOccurrences(of: " ", with: "%", options: NSString.CompareOptions.literal, range: nil)
        let query = SQL.SearchSpecies.replacingOccurrences(of: "@", with: searchQueryText, options: NSString.CompareOptions.literal, range: nil)
        
        //
        //  Run the SQL Query.
        //
        sqlite3_prepare_v2(self.database, query, -1, &statement, nil)
        while sqlite3_step(statement) == SQLITE_ROW
        {
            var specieDetail: SpecieSimpleModel = SpecieSimpleModel()
            
            specieDetail.id                     = Int(sqlite3_column_int64(statement, 0))
            specieDetail.commonName             = String(cString: sqlite3_column_text(statement, 1))
            specieDetail.specie                 = String(cString: sqlite3_column_text(statement, 5))
            specieDetail.genus                  = String(cString: sqlite3_column_text(statement, 12))
            specieDetail.family                 = String(cString: sqlite3_column_text(statement, 13))
            
            specieDetails.append(specieDetail)
        }
        sqlite3_finalize(statement)
        
        //
        //  Return the details of the specie that we found.
        //
        return specieDetails
    }
}
