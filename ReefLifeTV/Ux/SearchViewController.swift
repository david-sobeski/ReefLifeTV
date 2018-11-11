//
//  SearchViewController.swift
//  ReefLifeTV
//
//  Created by David Sobeski on 11/3/18.
//  Copyright © 2018 David Sobeski. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    // ---------------------------------------------------------------------------------------------
    // MARK: - IBOutlets
    
    fileprivate var searchResultsController: SpeciesCollectionViewController?
    
    // ---------------------------------------------------------------------------------------------
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        //  For some odd reason, Apple does not have InterfaceBuilder items for a UISearchController
        //  or a UISearchContainerViewContrller. Therefore, we need to code our search manually.
        //
        
        //
        //  Create a new search controller giving it a reference to ourself for the updateer. This
        //  means when the user taps a character for the search, we will be called back on this
        //  class. We also want to reuse our Collection view to display the species.
        //
        self.searchResultsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SpeciesCollectionViewController") as? SpeciesCollectionViewController
        let searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = self
                
        //
        //  Set up some basics display properties on the search controler.
        //
        searchController.searchBar.placeholder = "Search Species".localized
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.keyboardAppearance = .default
        
        //
        //  Add our search controller to the container view.
        //
        let searchContainerViewController = UISearchContainerViewController(searchController: searchController)

        //
        //  We need to initially account for the tab bar, so let's physically (well, you know what
        //  I mean), place it below the tab bar.
        //
        searchContainerViewController.view.frame = CGRect(x: 0.0,
                                                          y: 0.0,
                                                          width: self.view.bounds.width,
                                                          height: self.view.bounds.height)
        
        //
        //  Add the search container view to our subview and add the new view controller to our
        //  heirarchy by calling addChild.
        //
        self.view.addSubview(searchContainerViewController.view!)
        self.addChild(searchContainerViewController)
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
        if segue.identifier == nil {
            return
        }
        
        if segue.identifier! == Resource.SegueSearchResults
        {
            if let destination = segue.destination as? SpeciesCollectionViewController {
                self.searchResultsController = destination
                searchResultsController?.dataChanged(searchText: "")
            }
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    // ---------------------------------------------------------------------------------------------
    // MARK: - UISearchResultsUpdating Methods
    
    func updateSearchResults(for searchController: UISearchController) {
        if self.searchResultsController != nil {
            if (searchController.searchBar.text?.isEmpty)! {
                return
            }
            
            searchResultsController?.dataChanged(searchText: searchController.searchBar.text!)
        }
    }
}
