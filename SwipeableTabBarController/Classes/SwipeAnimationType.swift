//
//  SwipeAnimationType.swift
//  Pods
//
//  Created by Marcos Griselli on 2/1/17.
//
//

import UIKit

/// TODO (marcosgriselli): - Come up with a simpler protocol based on starting and ending vectors.

public typealias Direction = UIPageViewController.NavigationDirection

public protocol SwipeAnimationTypeProtocol {
    func addTo(containerView: UIView, fromView: UIView, toView: UIView)
    func prepare(fromView from: UIView, toView to: UIView, direction: Direction)
    func animation(fromView from: UIView, toView to: UIView, direction: Direction)
    func completion(fromView from: UIView, toView to: UIView, direction: Direction)
}

/// Different types of interactive animations.
///
/// - overlap: Previously selected tab will stay in place while the new tab slides in.
/// - sideBySide: Both tabs move side by side as the animation takes place.
/// - push: Replicates iOS default push animation.
public enum SwipeAnimationType: SwipeAnimationTypeProtocol {
    case overlap
    case sideBySide
    case push
    
    /// Setup the views hirearchy for different animations types.
    ///
    /// - Parameters:
    ///   - containerView: View that will contain the tabs views that will perform the animation
    ///   - fromView: Previously selected tab view.
    ///   - toView: New selected tab view.
    public func addTo(containerView: UIView, fromView: UIView, toView: UIView) {
        switch self {
        case .push:
            containerView.insertSubview(toView, belowSubview: fromView)
        default:
            containerView.addSubview(toView)
        }
    }
    
    /// Setup the views position prior to the animation start.
    ///
    /// - Parameters:
    ///   - from: Previously selected tab view.
    ///   - to: New selected tab view.
    ///   - direction: Direction in which the views will animate.
    public func prepare(fromView from: UIView, toView to: UIView, direction: Direction) {
        let screenWidth = UIScreen.main.bounds.size.width
        switch self {
        case .overlap:
            to.frame.origin.x = direction == .forward ? -screenWidth : screenWidth
        case .sideBySide:
            from.frame.origin.x = 0
            to.frame.origin.x = direction == .forward ? -screenWidth : screenWidth
        case .push:
            let scaledWidth = screenWidth / 6
            to.frame.origin.x = direction == .forward ? -scaledWidth : scaledWidth
            from.frame.origin.x = 0
        }
    }

    /// The animation to take place.
    ///
    /// - Parameters:
    ///   - from: Previously selected tab view.
    ///   - to: New selected tab view.
    ///   - direction: Direction in which the views will animate.
    public func animation(fromView from: UIView, toView to: UIView, direction: Direction) {
        let screenWidth = UIScreen.main.bounds.size.width
        switch self {
        case .overlap:
            to.frame.origin.x = 0
        case .sideBySide:
            from.frame.origin.x = direction == .forward ? screenWidth : -screenWidth
            to.frame.origin.x = 0
        case .push:
            to.frame.origin.x = 0
            from.frame.origin.x = direction == .forward ? screenWidth : -screenWidth
        }
    }
    
    /// The completion to call upon finishing animation.
    ///
    /// - Parameters:
    ///   - from: Previously selected tab view.
    ///   - to: New selected tab view.
    ///   - direction: Direction in which the views animated.
    public func completion(fromView from: UIView, toView to: UIView, direction: Direction) {
        switch self {
        default:
            return
        }
    }
}
