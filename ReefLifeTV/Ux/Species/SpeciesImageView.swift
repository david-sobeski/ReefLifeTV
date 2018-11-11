//
//  SpeciesImageView.swift
//  ReefLifeTV
//
//  Created by David Sobeski on 11/4/18.
//  Copyright © 2018 David Sobeski. All rights reserved.
//

import UIKit

class SpeciesImageView: UIImageView {
    //
    //  We need to override this class variable that will allow our UIImageView to become a
    //  focusable element.
    //
    override var canBecomeFocused: Bool {
        return true
    }
   
    //
    //
    //
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
    }
}
