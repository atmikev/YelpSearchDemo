//
//  ReviewTableViewCell.swift
//  YelpSearch
//
//  Created by Tyler Mikev on 12/10/17.
//  Copyright © 2017 Tyler Mikev. All rights reserved.
//

import UIKit
import Kingfisher

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeCreatedLabel: UILabel!
    @IBOutlet weak var reviewTextLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    public var review: Review! {
        didSet {
            show(review)
        }
    }

    private func show(_ review: Review) {
        
        userNameLabel.text = review.user.name
        reviewTextLabel.text = review.text
        ratingLabel.text = review.ratingString
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "MM/dd/YY hh:mm a"
        timeCreatedLabel.text = dateFormatter.string(from: review.timeCreated)
        
        userImageView.image = nil
        guard let url = URL(string: review.user.imageURL) else { return }
        let resource = ImageResource(downloadURL:url)
        userImageView.kf.setImage(with: resource,
                                  placeholder: nil,
                                  options: [.transition(.fade(0.2))],
                                  progressBlock: nil,
                                  completionHandler:nil)
    }
}
