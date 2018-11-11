//
//  SpecieDetailsViewController.swift
//  ReefLifeTV
//
//  Created by David Sobeski on 11/4/18.
//  Copyright © 2018 David Sobeski. All rights reserved.
//

import UIKit

class SpecieDetailsViewController: UIViewController, DetailsDelegate {
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Public Properties
    
    public var specieId: Int = -1
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - Internal Properties
    
    private var specieDetail: SpecieDetailModel        = SpecieDetailModel()
    private var speciePhotos: Array<SpeciePhotoModel>  = [SpeciePhotoModel]()
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - IBOutlets
    
    @IBOutlet var specieImageView: UIImageView!
    @IBOutlet var detailsTextView: UITextView!
    @IBOutlet var proertiesView: UIView!
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        //
        //  Fetch the details for our specie.
        //
        self.specieDetail = RLDatabase.shared.getSpecieDetail(specieId)
        
        //
        //  Fetch the photos for our specie.
        //
        self.speciePhotos = RLDatabase.shared.getSpeciePhotos(specieId)
        
        //
        //  Set all of our properties and details.
        //        
        if self.speciePhotos.count == 0 {
            self.specieImageView.image = UIImage(named: Resource.UnknownImage)//?.resizeTo(self.specieImageView.bounds)
        } else {
            self.specieImageView.image = UIImage(named: self.speciePhotos[0].name)//?.resizeTo(self.specieImageView.bounds)
        }
        
        //
        //  We need our UIImageView to support the ability to be tapped or clicked. Therefore,
        //  we need to enable user interaction.
        //
        self.specieImageView.isUserInteractionEnabled = true
        self.specieImageView.adjustsImageWhenAncestorFocused = true
        
        //
        //  We need our UITextView to have the ability to be selectable and scrollable.
        //
        self.detailsTextView.text = self.specieDetail.details
        self.detailsTextView.isSelectable = true
        self.detailsTextView.isUserInteractionEnabled = true
        self.detailsTextView.panGestureRecognizer.allowedTouchTypes = [UITouch.TouchType.indirect.rawValue] as [NSNumber]
    }
    
    //
    //  Notifies the view controller that a segue is about to be performed. Note, the default
    //  implementation does nothing, so there is no need to call the super class.
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == Resource.SegueProperties {
            if let propertiesViewController = segue.destination as? PropertiesViewController {
                propertiesViewController.delegate = self
            }
        }
    }
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - DetailsDelegate
    
    func getSpecieDetails() -> SpecieDetailModel {
        return self.specieDetail
    }
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - IBActions
    
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        //
        //  Since we can not add a touch to a UIImageView in Interface Builder, have to programmatically
        //  disply our view controller that is used to display our full image. We get the
        //  Storyboard ID for our detailed picture controller and we present it. We need to
        //  pass the ID of the specie to our detailed photo viewer so it can display the
        //  appropriate photo.
        //
        let photoViewController = UIStoryboard(name: Resource.StoryboardPhoto, bundle: nil).instantiateInitialViewController() as? PhotoViewController
        photoViewController?.photoModel = self.speciePhotos[0]
        
        //
        //  Show our new controller.
        //
        self.present(photoViewController!, animated: true, completion: nil)
    }
}

