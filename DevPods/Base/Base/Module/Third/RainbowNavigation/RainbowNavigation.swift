//
//  LLRainbowNavigationDelegate.swift
//  Pods
//
//  Created by Danis on 15/11/25.
//
//

open class RainbowNavigation: NSObject, UINavigationControllerDelegate {
    
    fileprivate weak var navigationController: UINavigationController?
    
    fileprivate var pushAnimator = RainbowPushAnimator()
    fileprivate var popAnimator = RainbowPopAnimator()
    fileprivate var dragPop = RainbowDragPop()
    
    override public init() {
        super.init()
        
        dragPop.popAnimator = popAnimator
    }
    
    open func wireTo(navigationController nc: UINavigationController) {
        self.navigationController = nc
        self.dragPop.navigationController = nc
        self.navigationController?.delegate = self
    }
    
    open func navigationController(_ navigationController: UINavigationController,
                                   animationControllerFor operation: UINavigationController.Operation,
                                   from fromVC: UIViewController,
                                   to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .pop {
            return popAnimator
        }
        return pushAnimator
    }
    
    open func navigationController(_ navigationController: UINavigationController,
                                   interactionControllerFor animationController: UIViewControllerAnimatedTransitioning)
    -> UIViewControllerInteractiveTransitioning? {
        if dragPop.interacting{
            return dragPop
        }else{
            if let last = navigationController.viewControllers.last as? RainbowColorSource{
                navigationController.navigationBar.rb.backgroundColor = last.navigationBarInColor
            }
            return nil
        }
    }
    
}
