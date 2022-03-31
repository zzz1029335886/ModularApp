//
//  BBShowView.swift
//  test
//
//  Created by zerry on 2018/4/18.
//  Copyright © 2018年 zerry. All rights reserved.
//

import UIKit
import SnapKit

enum BBShowViewDirection {
    case bottom
    case top
    case left
    case right
    case middle
}

typealias BBShowViewCompleted = (_ isShowed:Bool)->Void


class BBShowBackgroundScrollView: UIScrollView, UIGestureRecognizerDelegate {
    
    weak var contentScollView: UIScrollView?
    /**
     是否同时识别多个手势
     
     @param gestureRecognizer gestureRecognizer description
     @param otherGestureRecognizer otherGestureRecognizer description
     @return return value description
     */
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        /**
         如果其他手势的view是某些组件，则运行同时识别
         */
        guard let otherGesView = otherGestureRecognizer.view, otherGesView != self else { return true }
        guard let scrollView = otherGesView as? UIScrollView else { return false }
        self.contentScollView = scrollView
        return true
    }
}


class BBShowView: NSObject, UIScrollViewDelegate, UIGestureRecognizerDelegate{
    enum FeedbackStyle: Int {
        case none = -1
        case light = 0
        case medium = 1
        case heavy = 2
        case soft = 3
        case rigid = 4
    }
    
    static var isShowed: Bool{
        return !showedSet.isEmpty
    }
    
    static var showedSet = Set<BBShowView>()
    var tag: Int = 0
    var backRadio: CGFloat = 0.25
    var backAlpha: CGFloat = 0.425
    
    override init() {
        super.init()
        
        backgroundView.frame = keyWindow.bounds
        backgroundView.isUserInteractionEnabled = true
        
        shadowView.frame = backgroundView.bounds
        shadowView.backgroundColor = .black
        shadowView.alpha = 0.0
        backgroundView.addSubview(shadowView)
        
        let ges = UITapGestureRecognizer.init(target: self, action: #selector(touchBackgroundView(_:)))
        ges.delegate = self
        backgroundView.addGestureRecognizer(ges)
        
        scrollView.frame = backgroundView.bounds
        scrollView.delegate = self
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
        
        
        //        scrollView.decelerationRate = 0.01
        backgroundView.addSubview(scrollView)
        
    }
    
    
    var _hide = true
    //MARK: -- UIScrollViewDelegate
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        switch direction {
        case .left,.right:
            _hide = abs(velocity.x) >= backRadio
        default:
            _hide = abs(velocity.y) >= backRadio
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if isHiding {
            return
        }
        
        var y = scrollView.contentOffset.y;
        var x = scrollView.contentOffset.x;
        
        x = abs(x)
        y = abs(y)
        
        switch direction {
        case .top,.bottom:
            
            if y > (self.viewEndFrame.height * backRadio * 0.5){
                if _hide{
                    self.hide(true)
                }
            }
            
        case .left,.right:
            if x > (self.viewEndFrame.width * backRadio * 0.5){
                if _hide{
                    self.hide(true)
                }
            }
            
        default:
            
            break
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isHiding {
            return
        }
        
        if (self.direction == .left || self.direction == .top)
            && (scrollView.contentOffset.x < 0 || scrollView.contentOffset.y < 0){
            scrollView.contentOffset = CGPoint.zero
            return
        } else if (self.direction == .right || self.direction == .bottom)
                    && (scrollView.contentOffset.x > 0 || scrollView.contentOffset.y > 0) {
            scrollView.contentOffset = CGPoint.zero
            return
        }
        
        let y = scrollView.contentOffset.y
        let x = scrollView.contentOffset.x
        let radio = abs(y) / self.viewEndFrame.size.height + abs(x) / self.viewEndFrame.size.width;
        var alpha = 0.5 * radio
        alpha = backAlpha - abs(alpha)
        self.shadowView.alpha = alpha
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let location = touch.location(in: self.view)
        let inView = self.view?.bounds.contains(location) ?? false
        return !inView
    }
    
    //    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    //
    //        return true
    //    }
    
    //MARK:
    @objc
    private
    func touchBackgroundView(_ ges:UIGestureRecognizer){
        
        let point = ges.location(in: self.view)
        if (self.view?.layer.contains(point))!{
            return
        }
        
        if !self.bgEnable {
            return
        }
        
        self.hide()
    }
    
    weak var view : UIView?
    var viewEndFrame : CGRect = .zero
    var viewStartFrame : CGRect = .zero
    var viewStartAlpha: CGFloat = 1
    var viewEndAlpha: CGFloat = 1

    var direction: BBShowViewDirection = .bottom
    var isShowed: Bool = false
    var isHiding: Bool = false
    
    lazy var backgroundView = UIView()
    lazy var scrollView = BBShowBackgroundScrollView()
    lazy var shadowView = UIView()
    var keyWindow : UIView = UIApplication.shared.keyWindow!
    
    var completed: BBShowViewCompleted?
    
    var bgEnable: Bool = true
    var isSnap = false
    
    //MARK: -- 隐藏
    public func hide(_ isScrollGes: Bool = false, animated: Bool = true){
        
        if !isShowed {
            return
        }
        self.isHiding = true
        self.scrollView.isScrollEnabled = false
        
        UIView.animate(withDuration: animated ? 0.25 : 0, animations: {
            if self.isSnap && isScrollGes{
                self.view?.alpha = 0
            }else{
                self.view?.frame = self.viewStartFrame
                self.view?.alpha = self.viewStartAlpha
            }
            
            self.shadowView.alpha = 0.0
        }) { _ in
            self.isShowed = false
            self.completed?(false)
            self.bgEnable = true
            self.backgroundView.removeFromSuperview()
            self.view?.removeFromSuperview()
            self.view?.alpha = self.viewEndAlpha
            self.view?.frame = self.viewEndFrame
            self.isHiding = false
            BBShowView.showedSet.remove(self)
        }
    }
    
    deinit {
        print("BBShowView销毁")
    }
    
    func update(_ isAnimate: Bool = true) {
        guard let view = self.view else { return }
        if isAnimate {
            UIView.animate(withDuration: 0.25) {
                self.setSnapView(view: view)
            } completion: { (isCompletion) in
                self.viewStartFrame.size.height = view.frame.height
                self.viewEndFrame = view.frame
            }
        } else {
            self.setSnapView(view: view)
            self.viewStartFrame.size.height = view.frame.height
            self.viewEndFrame = view.frame
        }
    }
    
    fileprivate
    func setSnapView(view kView: UIView){
        var oldFrame = kView.frame
        kView.snp.removeConstraints()
        
        kView.snp.makeConstraints { (m) in
            m.leading.equalTo(kView.frame.origin.x)
            m.width.equalTo(kView.frame.width)
        }
        kView.layoutIfNeeded()
        
        oldFrame.origin.y = self.keyWindow.frame.height - kView.frame.height
        oldFrame.size.height = kView.frame.height
        kView.frame = oldFrame
        kView.snp.makeConstraints { (m) in
            m.top.equalTo(oldFrame.origin.y)
            m.height.equalTo(oldFrame.height)
        }
    }
    
    //MARK: --显示
    public func show(view kView:UIView,
                     direction kDirection:BBShowViewDirection){
        kView.isUserInteractionEnabled = true
        UIApplication.shared.currentWindow?.endEditing(true)
        
        if self.isShowed{
            return
        }else{
            self.isShowed = true
            self.keyWindow.addSubview(self.backgroundView)
        }
        
        self.scrollView.isScrollEnabled = self.bgEnable
        self.view = kView
        self.direction = kDirection
        self.scrollView.addSubview(kView)
        let windowFrame = self.keyWindow.bounds
        
        if kView.frame.height == 0 {
            self.isSnap = true
            setSnapView(view: kView)
        }else{
            self.isSnap = false
        }
        
        self.viewEndFrame = kView.frame
        self.viewEndAlpha = kView.alpha
        
        var startFrameX, startFrameY, startFrameWidth,startFrameHeight : CGFloat
        
        startFrameX = self.viewEndFrame.origin.x
        startFrameY = self.viewEndFrame.origin.y
        startFrameWidth = self.viewEndFrame.size.width
        startFrameHeight = self.viewEndFrame.size.height
        
        var isVertical = true
        var isMiddle = false
        
        switch direction {
        case .bottom:
            startFrameY = windowFrame.size.height
            
        case .top:
            startFrameY = -self.viewEndFrame.size.height
            
        case .left:
            isVertical = false
            startFrameX = -self.viewEndFrame.size.width
            
        case .right:
            isVertical = false
            startFrameX = windowFrame.size.width
            
        case .middle:
            isMiddle = true
//            startFrameX = windowFrame.size.width * 0.5
//            startFrameY = windowFrame.size.height * 0.5
//            startFrameWidth = 0.0
//            startFrameHeight = 0.0
        }
        
        var alpha: CGFloat
        if !isMiddle {
            alpha = kView.alpha
            if isVertical {
                self.scrollView.contentSize = CGSize(width: self.keyWindow.bounds.size.width, height: self.keyWindow.bounds.size.height + 0.5)
            }else{
                self.scrollView.contentSize = CGSize(width: self.keyWindow.bounds.size.width + 0.5, height: self.keyWindow.bounds.size.height)
            }
        }else{
            alpha = 0
        }
        
        viewStartFrame = CGRect(x: startFrameX, y: startFrameY, width: startFrameWidth, height: startFrameHeight)
        viewStartAlpha = alpha
        
        kView.frame = viewStartFrame
        kView.alpha = viewStartAlpha
        self.scrollView.contentOffset = .zero
        
        UIView.animate(withDuration: 0.25, animations: {
            kView.frame = self.viewEndFrame
            kView.alpha = self.viewEndAlpha
            self.shadowView.alpha = self.backAlpha
        }) { _ in
            self.completed?(true)
            BBShowView.showedSet.insert(self)
        }
    }
}

extension BBShowView {
    @discardableResult
    class func show(view: UIView,
                    direction: BBShowViewDirection = .bottom,
                    feedbackStyle: FeedbackStyle = .none,
                    complete: BBShowViewCompleted? = nil
    ) -> BBShowView{
        
        if feedbackStyle != .none {
            if #available(iOS 10.0, *) {
                if let style = UIImpactFeedbackGenerator.FeedbackStyle.init(rawValue: feedbackStyle.rawValue) {
                    UIImpactFeedbackGenerator.init(style: style).impactOccurred()
                }
            } else {
                // Fallback on earlier versions
            }
        }
        
        let showView = BBShowView()
        showView.tag = showedSet.count
        showView.completed = complete
        showView.show(view: view, direction: direction)
        return showView
    }
    
    class func hide(animated: Bool = true) {
        let arr = showedSet.sorted{$0.tag < $1.tag}
        arr.last?.hide(animated: animated)
    }
    
    class func hide(view: UIView, animated: Bool = true) {
        for showedView in showedSet {
            if showedView.view == view {
                showedView.hide(animated: animated)
                break
            }
        }
    }
}
