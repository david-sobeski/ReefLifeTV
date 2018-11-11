//
//  SpeciesCollectionViewController.swift
//  ReefLifeTV
//
//  Created by David Sobeski on 11/4/18.
//  Copyright © 2018 David Sobeski. All rights reserved.
//

import UIKit
import TVUIKit

class SpeciesCollectionViewController: UICollectionViewController, ReloadDataDelegate {
    // ---------------------------------------------------------------------------------------------
    // MARK: - Internal Properties
    
    private var species: Array<SpecieSimpleModel> = [SpecieSimpleModel]()
    fileprivate var selected: Int = RLDatabase.Invalid

    // ---------------------------------------------------------------------------------------------
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.species = RLDatabase.shared.getSpeciesSimple()
    }
    
    //
    //  Notifies the view controller that a segue is about to be performed. Note, the default
    //  implementation does nothing, so there is no need to call the super class.
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //
        //  Get the new view controller using segue.destinationViewController and paass the selected
        //  object (Specie) to the new view controller.
        //
        if segue.identifier! == Resource.SegueSpecieDetails
        {
            let specieDetailsViewController = segue.destination as? SpecieDetailsViewController
            
            if specieDetailsViewController != nil
            {
                specieDetailsViewController?.specieId = self.species[self.selected].id
            }
        }
    }
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Resource.SpeciesCell, for: indexPath)
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "speciesCell2", for: indexPath)

        //
        //  Get all of the components of the cell.
        //
        let specieImage: UIImageView    = cell.viewWithTag(Resource.SpeciesImageTag) as! UIImageView
        let specieName: UILabel         = cell.viewWithTag(Resource.SpeciesNameTag) as! UILabel
        specieName.enablesMarqueeWhenAncestorFocused = true
        
        //
        //  Set our specie name.
        //
        specieName.text = self.species[indexPath.row].specie
        
        //
        //  We now need to set our photo. First, we need to fetch the photo based on our specie
        //  id.
        //
        let photos = RLDatabase.shared.getSpeciePhotos(self.species[indexPath.row].id)
        
        //let poster: TVPosterView = TVPosterView(frame: CGRect(x: 0.0,
        //                                                     y: 0.0,
        //                                                     width: cell.bounds.width - (cell.bounds.width * 0.15),
        //                                                      height: cell.bounds.height - (cell.bounds.height * 0.15)
        //                                   ))
        
        //poster.imageView.contentMode = .scaleToFill
        //poster.title = self.species[indexPath.row].specie
        //poster.footerView?.titleLabel?.font = poster.footerView?.titleLabel?.font.withSize(22.0)
        
        //
        //  Set the image for our UIImageView.
        //
        if photos.isEmpty != true
        {
            specieImage.image = UIImage(named: photos[0].name)?.resizeTo(specieImage.bounds)
            //poster.imageView.image = UIImage(named: photos[0].name)
        }
        else
        {
            specieImage.image = UIImage(named: Resource.UnknownImage)?.resizeTo(specieImage.bounds)
            //poster.imageView.image = UIImage(named: Resource.UnknownImage)
        }
        
        //cell.addSubview(poster)
        return cell
    }
    
    //
    //  Returns the number of sections that we have. We only have 1.
    //
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //
    //  Return the number of species we have.
    //
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.species.count
    }
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - UICollectionViewDelegate Implementation
    
    //
    //  This method is called when a user taps on (or selects) a cell.
    //
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        //
        //  Save our selected row for later use.
        //
        self.selected = indexPath.row
        
        return true
    }
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - ReloadDataDelegate Methods
    
    public func dataChanged() {
        self.species = RLDatabase.shared.getSpeciesSimple()
        self.collectionView.reloadData()
    }
    
    public func dataChanged(typeId: Int) {
        self.species = RLDatabase.shared.getSpeciesSimpleByType(typeId)
        self.collectionView.reloadData()
    }
    
    public func dataChanged(groupName: String) {
        self.species = RLDatabase.shared.getSpeciesSimpleByGroup(groupName)
        self.collectionView.reloadData()
    }
    
    public func dataChanged(searchText: String) {
        self.species = RLDatabase.shared.searchSpecies(searchText)
        self.collectionView.reloadData()
    }
}
