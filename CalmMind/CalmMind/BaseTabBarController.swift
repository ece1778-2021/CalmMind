//
//  BaseTabBarController.swift
//  CalmMind
//
//  Created by Jun Chen on 2021/3/18.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    var latestHeartRate : Int = 200
    var firstHeartRate : Int = 200
    var currentMoodIndex : Int = 0
    var currentPBS : Float = 1.0
    var isDemoOn = false
    var lowerBounded = false
    var sadSongList = ["Nocturne in a Minor", "RÃªverie, L. 68_ Reverie", "Nocturne Op. 48 No. 2", "Calm", "Nocturne Op. 48 No. 1", "1-01 Unbraiding the Sun"]
    var sadBPMList = ["69", "68", "66", "54", "51", "49"]
    var sadHexList = ["#414510", "#626932", "#5688A8", "#907717", "#82671A", "#364129"]
    var happySongList = ["Songs without Words", "Nocturne in E Flat", "1-01 sleeping bag", "1-04 Moonlight Serenade", "Sunlight", "Ocean", "Sparkle", "1-07 Song On The Beach"]
    var happyBPMList = ["160", "110", "92", "83", "52", "44", "40", "30"]
    var happyHexList = ["#948786", "#5C96AA", "#212E29", "#555C48", "#58648E", "#A9B0A9", "#B9C1CA", "#D1AF72"]
    var neutralSongList = ["Songs without Words", "Nocturne in E Flat", "1-01 sleeping bag", "1-04 Moonlight Serenade", "Nocturne in a Minor", "RÃªverie, L. 68_ Reverie", "Nocturne Op. 48 No. 2", "Calm", "Sunlight", "Nocturne Op. 48 No. 1", "1-01 Unbraiding the Sun", "Ocean", "Sparkle", "1-07 Song On The Beach"]
    var neutralBPMList = ["160", "110", "92", "83", "69", "68", "66", "54", "52", "51", "49", "44", "40", "30"]
    var neutralHexList = ["#948786", "#5C96AA", "#212E29", "#555C48", "#414510", "#626932", "#5688A8", "#907717", "#58648E", "#82671A", "#364129", "#A9B0A9", "#B9C1CA", "#D1AF72"]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        selectedIndex = 0
        // Do any additional setup after loading the view.
        delegate = self
    }
    
}

// MARK: - UITabBarControllerDelegate
extension BaseTabBarController: UITabBarControllerDelegate {

    /*
     Called to allow the delegate to return a UIViewControllerAnimatedTransitioning delegate object for use during a noninteractive tab bar view controller transition.
     ref: https://developer.apple.com/documentation/uikit/uitabbarcontrollerdelegate/1621167-tabbarcontroller
     */
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TabBarAnimatedTransitioning()
    }

}

/*
 UIViewControllerAnimatedTransitioning
 A set of methods for implementing the animations for a custom view controller transition.
 ref: https://developer.apple.com/documentation/uikit/uiviewcontrolleranimatedtransitioning
 */
final class TabBarAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {

    /*
     Tells your animator object to perform the transition animations.
     */
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let destination = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }

        destination.alpha = 0.0
        destination.transform = .init(scaleX: 1.5, y: 1.5)
        transitionContext.containerView.addSubview(destination)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            destination.alpha = 1.0
            destination.transform = .identity
        }, completion: { transitionContext.completeTransition($0) })
    }

    /*
     Asks your animator object for the duration (in seconds) of the transition animation.
     */
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }

}
