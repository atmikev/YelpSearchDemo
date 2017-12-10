//
//  BusinessDetailViewController.swift
//  YelpSearch
//
//  Created by Tyler Mikev on 12/10/17.
//  Copyright © 2017 Tyler Mikev. All rights reserved.
//

import UIKit
import Kingfisher
import MBProgressHUD

class BusinessDetailViewController: UIViewController {

    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessRatingLabel: UILabel!
    @IBOutlet weak var businessPriceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    public var business: Business!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        show(business)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        self.view.addGestureRecognizer(panGesture)
    }
    
    @objc func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        
        if panGesture.state == .ended {
            let velocity = panGesture.velocity(in: view)
            
            if velocity.y >= 5 {
                dismiss(animated: true,
                        completion: nil)
            }
        }
    }
    
    @IBAction func closeButtonHandler() {
        dismiss(animated: true,
                completion: nil)
    }

    private func show(_ business: Business) {
        
        businessNameLabel.text = business.name
        businessRatingLabel.text = business.ratingString
        businessPriceLabel.text = business.priceString
        
        businessImageView.image = nil
        guard let url = URL(string: business.imageURL) else { return }
        let resource = ImageResource(downloadURL:url)
        businessImageView.kf.setImage(with: resource,
                                      placeholder: nil,
                                      options: [.transition(.fade(0.2))],
                                      progressBlock: nil,
                                      completionHandler:nil)
        
        let hud = MBProgressHUD(view: view)
        hud.removeFromSuperViewOnHide = true
        hud.isUserInteractionEnabled = false
        hud.label.text = "Retrieving Reviews"
        DispatchQueue.main.async {
            self.view.addSubview(hud)
            hud.show(animated: true)
        }
        
        func failed() {
            UIAlertController.showError(with: "Error",
                                        andMessage: "We were unable to retrieve any reviews. Please try again.",
                                        on: self)
        }
        
        if business.reviews.count == 0 {
            let request = BusinessReviewRequest(business: business)
            _ = Network.request(target: .getBusinessReviews(request: request),
                            success: { (json) in
                                DispatchQueue.main.async { hud.hide(animated: true) }
                                let response = BusinessReviewResponse(from: json)
                                self.business.reviews = response.reviews
                                self.reloadTable()
            },
                            error: { (error) in
                                DispatchQueue.main.async { hud.hide(animated: true) }
                                failed()
            },
                            failure: { (moyaError) in
                                DispatchQueue.main.async { hud.hide(animated: true) }
                                failed()
            })
            
        } else {
            reloadTable()
        }
        
    }
    
    private func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension BusinessDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return business.reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ReviewTableViewCell.self)) as! ReviewTableViewCell
        
        cell.review = business.reviews[indexPath.row]
        
        return cell
    }
    
}

extension BusinessDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
