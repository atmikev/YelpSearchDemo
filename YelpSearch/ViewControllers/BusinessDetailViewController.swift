//
//  BusinessDetailViewController.swift
//  YelpSearch
//
//  Created by Tyler Mikev on 12/10/17.
//  Copyright © 2017 Tyler Mikev. All rights reserved.
//

import UIKit
import Kingfisher

class BusinessDetailViewController: UIViewController {

    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessRatingLabel: UILabel!
    @IBOutlet weak var businessPriceLabel: UILabel!
    
    public var business: Business!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        businessRatingLabel.text = String(repeating:"\u{2B50}", count: business.rating)
        businessPriceLabel.text = String(repeating:"\u{1F4B0}", count: business.price.count)
        
        businessImageView.image = nil
        guard let url = URL(string: business.imageURL) else { return }
        let resource = ImageResource(downloadURL:url)
        businessImageView.kf.setImage(with: resource,
                                      placeholder: nil,
                                      options: [.transition(.fade(0.2))],
                                      progressBlock: nil,
                                      completionHandler:nil)
        
    }
}
