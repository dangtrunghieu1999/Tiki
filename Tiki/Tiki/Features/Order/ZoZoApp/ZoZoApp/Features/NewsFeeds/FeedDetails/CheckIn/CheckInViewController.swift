//
//  CheckInViewController.swift
//  ZoZoApp
//
//  Created by LAP12852 on 9/30/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import GooglePlaces

protocol CheckInViewControllerDelegate: class {
    func didCompleteSearch(_ place: GMSPlace)
}

class CheckInViewController: BaseViewController {
    
    // MARK: Properties
    
    public weak var delegate: CheckInViewControllerDelegate?
    
    private let filter: GMSAutocompleteFilter = {
        let filter = GMSAutocompleteFilter()
        filter.country = "VN"
        return filter
    }()
    
    // MARK: UIElement
    
    fileprivate lazy var resultsViewController: GMSAutocompleteResultsViewController = {
        let search = GMSAutocompleteResultsViewController()
        search.delegate = self
        search.autocompleteFilter = self.filter
        return search
    }()
    
    fileprivate lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: resultsViewController)
        search.searchBar.sizeToFit()
        search.searchBar.placeholder = TextManager.search.localized()
        search.hidesNavigationBarDuringPresentation = false
        search.searchResultsUpdater = self.resultsViewController
        search.delegate = self
        return search
    }()
    
    // MARK: Life Circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = false
        self.setupViewNavigationBar()
    }
    
    // MARK: SetupView
    
    private func setupViewNavigationBar() {
        self.navigationItem.titleView = self.searchController.searchBar
        self.title = ""
    }
    
}

// MARK: - GMSAutocompleteResultsViewControllerDelegate

extension CheckInViewController: GMSAutocompleteResultsViewControllerDelegate {
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        self.searchController.isActive = false
        self.delegate?.didCompleteSearch(place)
        self.dismiss(animated: true, completion: nil)
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

//MARK: - UISearchControllerDelegate

extension CheckInViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        self.navigationController?.popViewController(animated: true)
    }
}
