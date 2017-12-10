//
//  UIAlertControllerError.swift
//  YelpSearch
//
//  Created by Tyler Mikev on 12/9/17.
//  Copyright © 2017 Tyler Mikev. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    static func showError(with title: String, andMessage message: String, on controller: UIViewController) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok",
                                   style: .default,
                                   handler: nil)
        
        alertController.addAction(action)
        
        controller.present(alertController,
                           animated: true,
                           completion: nil)
    }
    
}
