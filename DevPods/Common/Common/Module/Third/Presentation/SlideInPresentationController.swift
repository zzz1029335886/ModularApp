/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

final class SlideInPresentationController: UIPresentationController {
    
    // MARK: - Properties
    fileprivate let dimmingView = DimmingView()
    var direction: PresentationDirection = .left()
    var bgEnable = true
    var backAlpha : CGFloat = 0.425
    var isVertical = false
    var _hide = true
    var backRadio: CGFloat = 0.2
    var isHiding: Bool = false
    
    weak var view : UIView?
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
        
        if let containerView = containerView {
            frame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView.bounds.size)
            switch direction {
            case .right(let width):
                frame.origin.x = containerView.frame.width - width
            case .bottom(let height):
                frame.origin.y = containerView.frame.height - height
            default:
                frame.origin = .zero
            }
        }
        
        return frame
    }
    
    // MARK: - Initializers
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, direction: PresentationDirection) {
        self.direction = direction
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        var isVertical : Bool
        switch direction {
        case .left, .right:
            isVertical = false
        default:
            isVertical = true
        }
        setupDimmingView(isVertical: isVertical)
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        guard let containerView = containerView else { return }
        
        containerView.insertSubview(dimmingView, at: 0)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimmingView]|", options: [], metrics: nil, views: ["dimmingView": dimmingView]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[dimmingView]|", options: [], metrics: nil, views: ["dimmingView": dimmingView]))
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        })
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        
        if let view = containerView?.subviews.last {
            view.removeFromSuperview()
            dimmingView.scrollView.addSubview(view)
            self.view = view
        }
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        switch direction {
        case .left(let width):
            return CGSize(width: width, height: parentSize.height)
            
        case .right(let width):
            return CGSize(width: width, height: parentSize.height)
            
        case .bottom(let height):
            return CGSize(width: parentSize.width, height: height)
            
        case .top(let height):
            return CGSize(width: parentSize.width, height: height)
            
        }
    }
}

extension SlideInPresentationController: UIScrollViewDelegate{
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print(abs(velocity.x))
        switch direction {
        case .left, .right:
            _hide = abs(velocity.x) >= 0.8
        default:
            _hide = abs(velocity.y) >= 0.8
        }
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if isHiding {
            return
        }
        guard let view = view else { return }
        
        var y = scrollView.contentOffset.y
        var x = scrollView.contentOffset.x
        
        x = abs(x)
        y = abs(y)
        
        switch direction {
        case .top, .bottom:
            if y > (view.frame.height * backRadio){
                if _hide{
                    self.hide(true)
                }
            }
        case .left,.right:
            if x > (view.frame.width * backRadio){
                if _hide{
                    self.hide(true)
                }
            }
        }
    }
    
    
    //MARK: -- 隐藏
    func hide(_ isScrollGes: Bool = false){
        presentingViewController.dismiss(animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        switch direction {
        case .left:
            if scrollView.contentOffset.x < 0{
                scrollView.contentOffset = CGPoint.zero
                return
            }
        case .right:
            if scrollView.contentOffset.x > 0{
                scrollView.contentOffset = CGPoint.zero
                return
            }
        case .bottom:
            if scrollView.contentOffset.y > 0{
                scrollView.contentOffset = CGPoint.zero
                return
            }
        case .top:
            if scrollView.contentOffset.y < 0{
                scrollView.contentOffset = CGPoint.zero
                return
            }
        }
        
        guard let view = view else { return }
        
        let y = scrollView.contentOffset.y
        let x = scrollView.contentOffset.x
        let radio = abs(y) / view.frame.size.height + abs(x) / view.frame.size.width;
        var alpha = 0.5 * radio
        alpha = backAlpha - abs(alpha)
        self.dimmingView.backgroundColor = UIColor(white: 0.0, alpha: alpha)
        
        if let contentScrollView = self.dimmingView.scrollView.contentScollView {
            if contentScrollView.isReachTop{
//                contentScrollView.contentOffset = .init(x: 0, y: -contentScrollView.adjustContentInset.top)
            }else{
                scrollView.contentOffset = .zero
            }
        }
    }
    
    func setupDimmingView(isVertical: Bool) {
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: backAlpha)
        dimmingView.alpha = 0.0
        
        dimmingView.scrollView.delegate = self
        
        if isVertical {
            dimmingView.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height + 0.5)
        } else {
            dimmingView.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width + 0.5, height: UIScreen.main.bounds.size.height)
        }
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(ges:)))
        recognizer.delegate = self
        dimmingView.addGestureRecognizer(recognizer)
    }
    
    @objc func handleTap(ges: UITapGestureRecognizer) {
        guard let view = view else { return }
        
        let point = ges.location(in: view)
        if view.layer.contains(point){
            return
        }
        
        if !self.bgEnable {
            return
        }
        
        self.hide()
    }
    
    class DimmingView: UIView {
        lazy var scrollView = BBShowBackgroundScrollView()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            addSubview(scrollView)
            scrollView.frame = self.bounds
            scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.showsVerticalScrollIndicator = false
            if #available(iOS 13.0, *) {
                scrollView.automaticallyAdjustsScrollIndicatorInsets = false
            } else {
                // Fallback on earlier versions
            }
            if #available(iOS 11.0, *) {
                scrollView.contentInsetAdjustmentBehavior = .never
            } else {
                // Fallback on earlier versions
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}

extension SlideInPresentationController: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let view = view else { return true }
        let location = touch.location(in: view)
        let inView = view.bounds.contains(location)
        return !inView
    }
}
