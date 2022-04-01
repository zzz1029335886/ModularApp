//
//  LLRainbowPopAnimator.swift
//  Pods
//
//  Created by Danis on 15/11/25.
//
//

import UIKit

class RainbowPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var animating = false
    var fromColor: UIColor?
    var toColor: UIColor?
    var fromSimilarColor: UIColor?
    var toSimilarColor: UIColor?

    // Calculate the middle Color with translation percent
    private func averageColor(fromColor: UIColor,
                              toColor: UIColor,
                              percent: CGFloat)
    -> UIColor {
        var fromRed: CGFloat = 0
        var fromGreen: CGFloat = 0
        var fromBlue: CGFloat = 0
        var fromAlpha: CGFloat = 0
        fromColor.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        
        var toRed: CGFloat = 0
        var toGreen: CGFloat = 0
        var toBlue: CGFloat = 0
        var toAlpha: CGFloat = 0
        toColor.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
        
        let nowRed = fromRed + (toRed - fromRed) * percent
        let nowGreen = fromGreen + (toGreen - fromGreen) * percent
        let nowBlue = fromBlue + (toBlue - fromBlue) * percent
        let nowAlpha = fromAlpha + (toAlpha - fromAlpha) * percent
//        printLog("r \(nowRed) g \(nowGreen) b \(nowBlue) a \(nowAlpha)")
        return UIColor(red: nowRed, green: nowGreen, blue: nowBlue, alpha: nowAlpha)
    }
    
    func update(_ navigationController: UINavigationController?, progress: CGFloat) {
        guard let toColor = toSimilarColor ?? toColor, let fromColor = fromSimilarColor ?? fromColor else { return }
//        if !toColor.responds(to: #selector(UIColor.getRed(_:green:blue:alpha:))) {
//            toColor = toSimilarColor ?? .init(white: 1, alpha: 1)
//        }
//        if !fromColor.responds(to: #selector(UIColor.getRed(_:green:blue:alpha:))) {
//            fromColor = fromSimilarColor ?? .init(white: 1, alpha: 1)
//        }
        
        let color = averageColor(fromColor: fromColor, toColor: toColor, percent: progress)
        navigationController?.navigationBar.rb.backgroundColor = color
    }
    
    func finish(_ navigationController: UINavigationController?) {
        navigationController?.navigationBar.rb.backgroundColor = toColor
    }
    
    func cancel(_ navigationController: UINavigationController?) {
        navigationController?.navigationBar.rb.backgroundColor = fromColor
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else { return }
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else { return }
        
        if let vc = fromVC as? RainbowColorSource {
            fromColor = vc.navigationBarInColor
            fromSimilarColor = vc.navigationBarInSimilarColor
        }
        if let vc = toVC as? RainbowColorSource {
            toColor = vc.navigationBarInColor
            toSimilarColor = vc.navigationBarInSimilarColor
        }
                
        let containerView = transitionContext.containerView
        let shadowMask = UIView(frame: containerView.bounds)
        shadowMask.backgroundColor = UIColor.black
        shadowMask.alpha = 0.3
        shadowMask.isUserInteractionEnabled = false
        
        let finalToFrame = transitionContext.finalFrame(for: toVC)
        toVC.view.frame = finalToFrame.offsetBy(dx: -finalToFrame.width * 0.5, dy: 0)
        
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        containerView.insertSubview(shadowMask, aboveSubview: toVC.view)
        
        let duration = self.transitionDuration(using: transitionContext)
        
        animating = true
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: .curveLinear,
            animations: {
                () -> Void in
                fromVC.view.frame = fromVC.view.frame.offsetBy(dx: fromVC.view.frame.width, dy: 0)
                toVC.view.frame = finalToFrame
                shadowMask.alpha = 0
                
            }) { (finished) -> Void in
            self.animating = false
            shadowMask.removeFromSuperview()
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
