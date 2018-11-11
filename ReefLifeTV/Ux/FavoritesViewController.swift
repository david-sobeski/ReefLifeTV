//
//  FavoritesViewController.swift
//  ReefLifeTV
//
//  Created by David Sobeski on 11/3/18.
//  Copyright © 2018 David Sobeski. All rights reserved.
//

import UIKit
import TVUIKit

class FavoritesViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let poster: TVPosterView = TVPosterView(frame: CGRect(x: 10, y: 700, width: 300, height: 200))
        poster.imageView.image = UIImage(named: "77896443_full.jpg")
        poster.imageView.contentMode = .scaleToFill
        //poster.imageView.clipsToBounds = true
        //poster.imageView.adjustsImageWhenAncestorFocused = true

        poster.title = "Unknown Image 2016"
        poster.footerView?.titleLabel?.font = poster.footerView?.titleLabel?.font.withSize(22.0)

        self.view.addSubview(poster)
    }
}

