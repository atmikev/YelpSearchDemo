//
//  BusinessTableViewController.swift
//  YelpSearch
//
//  Created by Tyler Mikev on 12/9/17.
//  Copyright © 2017 Tyler Mikev. All rights reserved.
//

import UIKit
import CoreLocation
import Moya
import MBProgressHUD

class BusinessTableViewController: UITableViewController {
    
    private var businesses = [Business]()
    private var lastRequest: Cancellable?
    private var selectedIndex: IndexPath?
    
    private let searchController = UISearchController(searchResultsController: nil)

    enum Segue: String {
        case detailSegue = "detailSegue"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup(searchController)
        setup(tableView)
        
        navigationItem.hidesSearchBarWhenScrolling = false
        
    }
    
    private func setup(_ tableView: UITableView) {
        let noResultsView = Bundle.main.loadNibNamed("NoResultsView", owner: nil, options: nil)?.first as? UIView
        tableView.backgroundView = noResultsView
    }
    
    private func setup(_ searchController: UISearchController) {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Businesses"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        if identifier == Segue.detailSegue.rawValue {
            guard let indexPath = selectedIndex else { return }
            
            let destinationViewController = segue.destination as! BusinessDetailViewController
            destinationViewController.business = businesses[indexPath.row]
            destinationViewController.transitioningDelegate = self
        }
    }

    //MARK: UITableViewDataSource Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BusinessTableViewCell.self)) as! BusinessTableViewCell
        
        let business = businesses[indexPath.row]
        cell.business = business
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        performSegue(withIdentifier: Segue.detailSegue.rawValue, sender: nil)
    }
}

extension BusinessTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
       
        if lastRequest != nil {
            lastRequest!.cancel()
            lastRequest = nil
        }
        
        guard searchText != "" else {
            businesses = []
            reloadTable()
            return
        }
        
        let request = SearchBusinessesRequest(at: CLLocationCoordinate2DMake(41.892179, -87.636655),
                                              with: searchText)
        let hud = MBProgressHUD(view: view)
        hud.removeFromSuperViewOnHide = true
        hud.isUserInteractionEnabled = false
        hud.label.text = "Searching"
        DispatchQueue.main.async {
            self.view.addSubview(hud)
            hud.show(animated: true)
        }
        
        func failed() {
            UIAlertController.showError(with: "Error",
                                        andMessage: "Something went wrong. Please try again.",
                                        on: self)
        }
        
        lastRequest = Network.request(target: .getBusinesses(request: request),
                                      success: { (json) in
                                        DispatchQueue.main.async {
                                            hud.hide(animated: true)
                                        }

                                        let response = SearchBusinessesResponse(from: json)
                                        self.businesses = response.businesses
                                        self.reloadTable()
        },
                                      error: { (error) in
                                        DispatchQueue.main.async {
                                            hud.hide(animated: true)
                                        }
                                        
                                        failed()
        },
                                      failure: { (moyaError) in
                                        DispatchQueue.main.async {
                                            hud.hide(animated: true)
                                        }
                                        
                                        switch moyaError {
                                        case .imageMapping(_), .jsonMapping(_), .stringMapping(_), .statusCode(_), .requestMapping(_):
                                            failed()
                                        case .underlying(let error as NSError, _):
                                            if error.code != -999 {
                                                failed()
                                            }
                                        }
                                        
                                        
        })
    }
    
}

extension BusinessTableViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let indexPath = selectedIndex,
            let cell = tableView.cellForRow(at: indexPath) else {
                
                return nil
                
        }
        
        let rect = tableView.rectForRow(at: indexPath)
        let frame = tableView.convert(rect, to: view.superview)
        let animator = BusinessDetailAnimationController(cellContentView: cell.contentView,
                                                         initialFrame: frame)
        
        selectedIndex = nil
        
        return animator
    }
    
}
