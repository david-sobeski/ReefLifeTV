//
//  PropertiesViewController.swift
//  ReefLifeTV
//
//  Created by David Sobeski on 11/4/18.
//  Copyright © 2018 David Sobeski. All rights reserved.
//

import UIKit

class PropertiesViewController: UITableViewController {
    // ---------------------------------------------------------------------------------------------
    // MARK: - Public Properties
    
    public var delegate: DetailsDelegate?
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - IBOutles
    
    @IBOutlet var commanNameCell: UITableViewCell!
    @IBOutlet var genusCell: UITableViewCell!
    @IBOutlet var familyCell: UITableViewCell!
    @IBOutlet var orderCell: UITableViewCell!
    @IBOutlet var iucnClassificationCell: UITableViewCell!
    @IBOutlet var groupCell: UITableViewCell!
    @IBOutlet var typeCell: UITableViewCell!
    @IBOutlet var maxSizeCell: UITableViewCell!
    @IBOutlet var regionsCell: UITableViewCell!
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - UITableViewDelegate Methods
    
    //
    //  A table view sends this message to its delegate just before it uses cell to draw a row,
    //  thereby permitting the delegate to customize the cell object before it is displayed. This
    //  method gives the delegate a chance to override state-based properties set earlier by the
    //  table view, such as selection and background color. After the delegate returns, the
    //  table view sets only the alpha and frame properties, and then only when animating rows
    //  as they slide in or out.
    //
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let specieDetail = delegate?.getSpecieDetails()
        
        switch indexPath.row {
        case 0: self.commanNameCell.detailTextLabel!.text           = specieDetail!.commonName
        case 1: self.genusCell.detailTextLabel!.text                = specieDetail!.genus
        case 2: self.familyCell.detailTextLabel!.text               = specieDetail!.family
        case 3: self.orderCell.detailTextLabel!.text                = specieDetail!.order
        case 4: self.iucnClassificationCell.detailTextLabel!.text   = specieDetail!.iucnClassification
        case 5: self.groupCell.detailTextLabel!.text                = specieDetail!.group
        case 6: self.typeCell.detailTextLabel!.text                 = specieDetail!.type
        case 7: self.maxSizeCell.detailTextLabel!.text              = specieDetail!.maxSize
        case 8: self.regionsCell.detailTextLabel!.text              = specieDetail!.regions
        default:
            break
        }
    }
}
