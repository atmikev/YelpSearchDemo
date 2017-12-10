//
//  BusinessTableViewCell.swift
//  YelpSearch
//
//  Created by Tyler Mikev on 12/9/17.
//  Copyright © 2017 Tyler Mikev. All rights reserved.
//

import UIKit
import Kingfisher

class BusinessTableViewCell: UITableViewCell {

    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    public var business: Business! {
        didSet {
            show(business)
        }
    }
    
    private func show(_ business: Business) {
        businessNameLabel.text = business.name
        ratingLabel.text = String(repeating:"\u{2B50}", count: business.rating)
        priceLabel.text = String(repeating:"\u{1F4B0}", count: business.price.count)
        
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
