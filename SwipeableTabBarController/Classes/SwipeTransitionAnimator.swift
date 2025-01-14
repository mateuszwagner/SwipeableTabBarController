//
//  SwipeAnimation.swift
//  SwipeableTabBarController
//
//  Created by Marcos Griselli on 1/31/17.
//  Copyright © 2017 Marcos Griselli. All rights reserved.
//

import UIKit

/// Swipe animation conforming to `UIViewControllerAnimatedTransitioning`
/// Can be replaced by any other class confirming to `UIViewControllerTransitioning`
/// on your `SwipeableTabBarController` subclass.
@objc(SwipeTransitionAnimator)
class SwipeTransitionAnimator: NSObject, SwipeTransitioningProtocol {

    // MARK: - SwipeTransitioningProtocol
    var animationDuration: TimeInterval
    var targetEdge: UIRectEdge
    var animationType: SwipeAnimationTypeProtocol = SwipeAnimationType.sideBySide

    /// Init with injectable parameters
    ///
    /// - Parameters:
    ///   - animationDuration: time the transitioning animation takes to complete
    ///   - animationType: animation type to perform while transitioning
    init(animationDuration: TimeInterval = 0.33,
         targetEdge: UIRectEdge = .right,
         animationType: SwipeAnimationTypeProtocol = SwipeAnimationType.sideBySide) {
        self.animationDuration = animationDuration
        self.targetEdge = targetEdge
        self.animationType = animationType
        super.init()
    }

    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return (transitionContext?.isAnimated == true) ? animationDuration : 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        //swiftlint:disable force_unwrapping
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        //swiftlint:enable force_unwrapping
        let direction: Direction = targetEdge == .right ? .forward : .reverse

        animationType.addTo(containerView: containerView, fromView: fromView, toView: toView)
        animationType.prepare(fromView: fromView, toView: toView, direction: direction)
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: [.curveLinear, .preferredFramesPerSecond60],
                       animations: {
                        self.animationType.animation(fromView: fromView, toView: toView, direction: direction)
        }, completion: { _ in
            self.animationType.completion(fromView: fromView, toView: toView, direction: direction)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
