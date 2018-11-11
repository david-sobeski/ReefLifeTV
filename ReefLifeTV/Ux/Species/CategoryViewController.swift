//
//  CategoryViewController.swift
//  ReefLifeTV
//
//  Created by David Sobeski on 11/3/18.
//  Copyright © 2018 David Sobeski. All rights reserved.
//

import UIKit

class CategoryViewController: UITableViewController {
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Constant Definitions
    
    let NUMBER_OF_SECTIONS: Int = 3
    let SECTION_ALL: Int        = 0
    let SECTION_TYPES: Int      = 1
    let SECTION_GROUPS: Int     = 2
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Private Properties
    
    private var types: [Type] = []
    private var groups: [Group] = []
    private var cachedCellIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.groups = RLDatabase.shared.getGroupsAlphabetical()
        self.types = RLDatabase.shared.getTypes()
    }
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - UITableViewDataSource Methods
    
    //
    //  The returned UITableViewCell object is frequently one that the application reuses for
    //  performance reasons. You should fetch a previously created cell object that is marked for
    //  reuse by sending a dequeueReusableCell(withIdentifier:) message to tableView. Various
    //  attributes of a table cell are set automatically based on whether the cell is a separator
    //  and on information the data source provides, such as for accessory views and editing
    //  controls.
    //
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell")!
        
        switch indexPath.section {
        case SECTION_ALL:
            cell.textLabel!.text = "All".localized
            cell.detailTextLabel!.text = String(describing: RLDatabase.shared.getSpeciesCount())
            
        case SECTION_TYPES:
            cell.textLabel!.text = self.types[indexPath.row].name
            let specieCount = RLDatabase.shared.getSpecieCountByTypeId(self.types[indexPath.row].id)
            cell.detailTextLabel!.text = String(describing: specieCount)
            break
            
        case SECTION_GROUPS:
            cell.textLabel!.text = self.groups[indexPath.row].name
            let specieCount = RLDatabase.shared.getSpecieCountByGroupdId(self.groups[indexPath.row].id)
            cell.detailTextLabel!.text = String(describing: specieCount)
            
        default:
            break
        }
        
        return cell
    }

    //
    //  Return the number of sections in the table view.
    //
    override func numberOfSections(in tableView: UITableView) -> Int {
        return NUMBER_OF_SECTIONS
    }
    
    //
    //  Return the number of rows in a given section of a table view.
    //
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows: Int = 0
        
        switch section {
        case SECTION_ALL:           numberOfRows = 1
        case SECTION_TYPES:         numberOfRows = RLDatabase.shared.getTypessCount()
        case SECTION_GROUPS:        numberOfRows = RLDatabase.shared.getGroupsCount()
        default:                    numberOfRows = 0
        }
        
        return numberOfRows
    }
    
    //
    //  Asks the data source for the title of the header of the specified section of the table view.
    //
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionTitle = ""
        
        switch section {
        case SECTION_ALL:           sectionTitle = "Species".localized
        case SECTION_TYPES:         sectionTitle = "Types".localized
        case SECTION_GROUPS:        sectionTitle = "Groups".localized
        default:                    break
        }
        
        return sectionTitle
    }
    
    //
    //  The specified row is now selected.
    //
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let details: SpeciesCollectionViewController = (self.splitViewController?.viewControllers[1] as? SpeciesCollectionViewController)!
        
        switch indexPath.section {
        case SECTION_ALL:           details.dataChanged()
        case SECTION_TYPES:         details.dataChanged(typeId: self.types[indexPath.row].id)
        case SECTION_GROUPS:        details.dataChanged(groupName: self.groups[indexPath.row].name)
        default:                    break
        }
    }
    
    //
    //  The row in the table was highlighted.
    //
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let details: SpeciesCollectionViewController = (self.splitViewController?.viewControllers[1] as? SpeciesCollectionViewController)!
        
        switch indexPath.section {
        case SECTION_ALL:           details.dataChanged()
        case SECTION_TYPES:         details.dataChanged(typeId: self.types[indexPath.row].id)
        case SECTION_GROUPS:        details.dataChanged(groupName: self.groups[indexPath.row].name)
        default:                    break
        }
    
        return true
    }
}
