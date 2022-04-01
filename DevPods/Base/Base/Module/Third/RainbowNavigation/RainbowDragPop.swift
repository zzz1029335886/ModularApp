//
//  LLRainbowDragPop.swift
//  Pods
//
//  Created by Danis on 15/11/25.
//
//

class RainbowDragPop: UIPercentDrivenInteractiveTransition {
    
    var interacting = false
    weak var navigationController: UINavigationController? {
        didSet {
            let panGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            panGesture.edges = UIRectEdge.left
            navigationController?.view.addGestureRecognizer(panGesture)
        }
    }
    weak var popAnimator: RainbowPopAnimator?
    
    override var completionSpeed: CGFloat {
        get {
            return max(CGFloat(0.5), 1 - self.percentComplete)
        } set {
            self.completionSpeed = newValue
        }
    }
    
    @objc func handlePan(_ panGesture: UIScreenEdgePanGestureRecognizer) {
        guard let view = panGesture.view else { return }
        guard let popAnimator = popAnimator else { return }
        guard let navigationController = navigationController else { return }
        
        let offset = panGesture.translation(in: view)
        let velocity = panGesture.velocity(in: view)
        view.endEditing(true)
        
        switch panGesture.state {
        case .began:
            if !popAnimator.animating {
                interacting = true
                if velocity.x > 0 && navigationController.viewControllers.count > 0 {
                    navigationController.popViewController(animated: true)
                }
            }
        case .changed:
            if interacting {
                var progress = offset.x / view.bounds.width
                progress = max(progress, 0)
                self.update(progress)
            }
        case .ended:
            if interacting {
                if panGesture.velocity(in: view).x > 0 {
                    self.finish()
                }else {
                    self.cancel()
                }
                interacting = false
            }
        case .cancelled:
            if interacting {
                self.cancel()
                interacting = false
            }
        default:
            break
        }
    }
    
    override func update(_ percentComplete: CGFloat) {
        super.update(percentComplete)
        
        popAnimator?.update(navigationController, progress: percentComplete)
    }
    
    override func finish() {
        super.finish()
        
        popAnimator?.finish(navigationController)
    }
    
    override func cancel() {
        super.cancel()
        
        popAnimator?.cancel(navigationController)
    }    
}
