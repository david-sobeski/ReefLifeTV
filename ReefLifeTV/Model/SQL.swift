//
//  SQL.swift
//  ReefLifeTV
//
//  Created by David Sobeski on 11/3/18.
//  Copyright © 2018 David Sobeski. All rights reserved.
//

import Foundation

//
//  This structure contains all of our SQL strings.
//
struct SQL
{
    // ---------------------------------------------------------------------------------------------
    // MARK: - Reef Life (Species) DB Statements
    
    //
    //  With SELECT queries, in code, you must use String(format:...). We use format tokens in
    //  the string in order to take parameters.
    //
    
    static let SelectTypes                  = "SELECT * FROM RL_Types"
    static let SelectGroups                 = "SELECT * FROM RL_Groups"
    static let SelectGroupsAlphabetical     = "SELECT * FROM RL_Groups ORDER BY UPPER(RL_Groups.name) ASC"
    static let SelectTypeNameForGroupName   = "SELECT RL_Types.name FROM RL_Types INNER JOIN RL_Groups ON RL_Types.id = RL_Groups.rl_type_id WHERE RL_Groups.name = \"%@\""
    static let SelectGroupNamesForTypeId    = "SELECT RL_Groups.name FROM RL_Groups WHERE RL_Groups.rl_type_id = %d ORDER BY UPPER(RL_Groups.name) ASC"
    static let SelectGroupNamesForTypeName  = "SELECT RL_Groups.name FROM RL_Groups INNER JOIN RL_Types ON RL_Groups.rl_type_id = RL_Types.id WHERE RL_Types.name = \"%@\" ORDER BY UPPER(RL_Groups.name) ASC"
    static let SelectTypeIdFromName         = "SELECT id FROM RL_Types WHERE name = \"%@\""
    
    static let SelectSpecieSimple           = "SELECT RL_Species.common_name, RL_Species.specie, RL_Families.name, RL_Genera.name FROM RL_Species INNER JOIN RL_Families, RL_Genera ON RL_Families.id = rl_family_id AND RL_Genera.id = RL_Species.rl_genus_id WHERE RL_Species.id = %d"
    static let SelectSpeciesSimple          = "SELECT RL_Species.id, RL_Species.common_name, RL_Species.specie, RL_Families.name, RL_Genera.name FROM RL_Species INNER JOIN RL_Families, RL_Genera ON RL_Families.id = rl_family_id AND RL_Genera.id = RL_Species.rl_genus_id ORDER BY RL_Species.specie ASC"
    static let SelectSpeciesSimpleByFilter  = "SELECT RL_Species.id, RL_Species.common_name, RL_Species.specie, RL_Families.name, RL_Genera.name FROM RL_Species INNER JOIN RL_Families, RL_Genera, RL_Groups ON RL_Families.id = rl_family_id AND RL_Genera.id = RL_Species.rl_genus_id AND RL_Groups.id = RL_Species.rl_group_id WHERE RL_Groups.name = \"%@\" ORDER BY RL_Species.specie ASC"
    static let SelectSpeciesSimpleByType    = "SELECT RL_Species.id, RL_Species.common_name, RL_Species.specie, RL_Families.name, RL_Genera.name FROM RL_Species INNER JOIN RL_Families, RL_Genera, RL_Groups, RL_Types ON RL_Families.id = rl_family_id AND RL_Genera.id = RL_Species.rl_genus_id AND RL_Groups.id = RL_Species.rl_group_id AND RL_Types.id = RL_Groups.rl_type_id WHERE RL_Types.id = %d ORDER BY RL_Species.specie ASC"
    static let SelectSpecieDetail           = "SELECT common_name, common_name_fr, common_name_es, common_name_de, specie, max_size, " +
                                              "regions, details, details_credit_source, details_credit_link, details_credit_date, " +
                                              "RL_Genera.name, RL_Families.name, RL_Orders.name, RL_IUCNClassifications.name, "  +
                                              "RL_Groups.name, RL_Types.name FROM RL_Species INNER JOIN RL_Genera, " +
                                              "RL_Families, RL_Orders, RL_IUCNClassifications, RL_Groups, RL_Types " +
                                              "ON RL_Genera.id = RL_Species.rl_genus_id AND " +
                                              "RL_Families.id = rl_family_id AND " +
                                              "RL_Orders.id = rl_order_id AND " +
                                              "RL_IUCNClassifications.id = rl_iucn_classification_id AND  " +
                                              "RL_Groups.id = rl_group_id AND  " +
                                              "RL_Types.id = RL_Groups.rl_type_id " +
                                              "WHERE RL_Species.id = %d"
    static let SelectSpeciePhotos           = "SELECT * from RL_SpeciesPhotos WHERE rl_species_id = %d"
    
    static let TypesCount                   = "SELECT COUNT(*) FROM RL_Types"
    static let GroupsCount                  = "SELECT COUNT(*) FROM RL_Groups"
    static let SpeciesCount                 = "SELECT COUNT(*) FROM RL_Species"
    static let GroupsCountByTypeId          = "SELECT COUNT(*) FROM RL_Groups WHERE RL_Groups.rl_type_id= %d"
    static let GroupsCountByTypeName        = "SELECT COUNT(*) FROM RL_Groups INNER JOIN RL_Types ON RL_Groups.rl_type_id = RL_Types.id WHERE RL_Types.name = \"%@\""
    static let SpecieCountByGroupdId        = "SELECT COUNT(*) FROM RL_Species WHERE rl_group_id = %d"    
    static let SpecieCountByTypeId          = "SELECT COUNT(*) FROM RL_Species INNER JOIN RL_Families, RL_Genera, RL_Groups, RL_Types ON RL_Families.id = rl_family_id AND RL_Genera.id = RL_Species.rl_genus_id AND RL_Groups.id = RL_Species.rl_group_id AND RL_Types.id = RL_Groups.rl_type_id WHERE RL_Types.id = %d"

    
    static let SearchSpecies                = "SELECT RL_Species.id, common_name, common_name_fr, common_name_es, common_name_de, specie, max_size, " +
                                              "regions, details, details_credit_source, details_credit_link, details_credit_date, " +
                                              "RL_Genera.name, RL_Families.name, RL_Orders.name, RL_IUCNClassifications.name, "  +
                                              "RL_Groups.name, RL_Types.name FROM RL_Species INNER JOIN RL_Genera, " +
                                             "RL_Families, RL_Orders, RL_IUCNClassifications, RL_Groups, RL_Types " +
                                              "ON RL_Genera.id = RL_Species.rl_genus_id AND " +
                                              "RL_Families.id = rl_family_id AND " +
                                              "RL_Orders.id = rl_order_id AND " +
                                              "RL_IUCNClassifications.id = rl_iucn_classification_id AND  " +
                                              "RL_Groups.id = rl_group_id AND  " +
                                              "RL_Types.id = RL_Groups.rl_type_id " +
                                              "WHERE " +
                                                  "RL_Species.common_name LIKE \"%@%\" OR " +
                                                  "RL_Species.common_name_fr LIKE \"%@%\" OR " +
                                                  "RL_Species.common_name_es LIKE \"%@%\" OR " +
                                                  "RL_Species.common_name_de LIKE \"%@%\" OR " +
                                                  "RL_Species.common_name LIKE \"%@%\" OR " +
                                                  "RL_Species.specie LIKE \"%@%\" OR " +
                                                  "RL_Species.common_name LIKE \"%@%\" OR " +
                                                  "RL_Species.max_size LIKE \"%@%\" OR " +
                                                  "RL_Species.regions LIKE \"%@%\" OR " +
                                                  "RL_Species.details LIKE \"%@%\" OR " +
                                                  "RL_Species.details_credit_source LIKE \"%@%\" OR " +
                                                  "RL_Species.details_credit_link LIKE \"%@%\" OR " +
                                                  "RL_Species.details_credit_date LIKE \"%@%\" OR " +
                                                  "RL_Genera.name LIKE \"%@%\" OR " +
                                                  "RL_Families.name LIKE \"%@%\" OR " +
                                                  "RL_Orders.name LIKE \"%@%\" OR " +
                                                  "RL_IUCNClassifications.name LIKE \"%@%\" OR " +
                                                  "RL_Groups.name LIKE \"%@%\" OR " +
                                                  "RL_Types.name LIKE \"%@%\" ORDER BY UPPER(RL_Species.common_name) ASC"
}
