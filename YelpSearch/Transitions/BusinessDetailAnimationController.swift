//
//  BusinessDetailAnimationController.swift
//  YelpSearch
//
//  Created by Tyler Mikev on 12/10/17.
//  Copyright © 2017 Tyler Mikev. All rights reserved.
//

import UIKit

class BusinessDetailAnimationController: NSObject {
    
    private let initialFrame: CGRect
    private let cellContentView: UIView
    private let contentSuperView: UIView
    
    init(cellContentView: UIView, initialFrame: CGRect) {
        self.cellContentView = cellContentView
        self.contentSuperView = cellContentView.superview!
        self.initialFrame = initialFrame
    }

}

extension BusinessDetailAnimationController: UIViewControllerAnimatedTransitioning {
   
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let snapshot = toVC.view.snapshotView(afterScreenUpdates: true)
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        toVC.view.isHidden = true
        
        snapshot.alpha = 0
        snapshot.layer.masksToBounds = true
        
        let finalFrame = transitionContext.finalFrame(for: toVC)
        snapshot.frame = finalFrame
        
        let duration = transitionDuration(using: transitionContext)
        
        self.cellContentView.removeFromSuperview()
        self.cellContentView.frame = self.initialFrame
        fromVC.view.addSubview(self.cellContentView)
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModePaced,
            animations: {
                
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/4) {
                    var frame = self.cellContentView.frame
                    frame.origin.y = 44
                    self.cellContentView.frame = frame
                }

                UIView.addKeyframe(withRelativeStartTime: 3/4, relativeDuration: 1/4) {
                    snapshot.alpha = 1
                }
                
        },
            completion: { _ in
                self.cellContentView.removeFromSuperview()
                self.contentSuperView.addSubview(self.cellContentView)
                self.cellContentView.frame.origin = CGPoint(x: 0, y: 0)
                
                toVC.view.isHidden = false
                snapshot.removeFromSuperview()
                fromVC.view.layer.transform = CATransform3DIdentity
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
}
