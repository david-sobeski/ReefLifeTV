//
//  PhotoViewController.swift
//  ReefLifeTV
//
//  Created by David Sobeski on 11/5/18.
//  Copyright © 2018 David Sobeski. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    // ---------------------------------------------------------------------------------------------
    // MARK: - IBOutlets
    @IBOutlet var specieImageView: UIImageView!
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Public Properties
    
    public var photoModel: SpeciePhotoModel?
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let model = photoModel {
            self.specieImageView.image = UIImage(named: model.name)
        }
    }
}

