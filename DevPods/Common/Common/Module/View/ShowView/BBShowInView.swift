//
//  BBShowInView.swift
//  BrainBank
//
//  Created by zerry on 2021/2/23.
//  Copyright © 2021年 zerry. All rights reserved.
//

import UIKit

enum BBShowInViewDirection {
    case bottom
    case top
    case left
    case right
    case middle
}

typealias BBShowInViewCompleted = (_ isShowed:Bool)->Void

/**
 弹框显示
 */
class BBShowInView: NSObject, UIGestureRecognizerDelegate{
    static var showedSet = Set<BBShowInView>()
    
    var timer : Timer?

    func startTimer() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 5,
                                          target: self,
                                          selector: #selector(scheduledTimer),
                                          userInfo: nil, repeats: true)
    }
    
    @objc
    func scheduledTimer() {
        if keyView == nil {
            self.hide()
        }
    }
    
    override init() {
        super.init()
        setUpSubviews()
    }
    
    func setUpSubviews(){
        backgroundView.clipsToBounds = true
        
        let ges = UITapGestureRecognizer.init(target: self, action: #selector(touchBackgroundView(_:)))
        ges.delegate = self
        backgroundView.addGestureRecognizer(ges)
        
        shadowView.frame = backgroundView.bounds
        shadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        shadowView.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.5)
        shadowView.alpha = 0.0
        backgroundView.addSubview(shadowView)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let view = view else { return true }
        let location = touch.location(in: view)
        let inView = view.bounds.contains(location)
        return !inView
    }
    
    //MARK:
    @objc private
    func touchBackgroundView(_ ges: UIGestureRecognizer){
        
        guard let view = view else { return }
        let point = ges.location(in: view)
        if view.layer.contains(point){
            return
        }
        
        guard bgEnable else {
            return
        }
        hide()
    }
    
    weak var view: UIView?
    var viewEndFrame: CGRect = .zero
    var viewStartFrame: CGRect = .zero
    var backgroundViewFrame: CGRect = .zero
    
    var direction = BBShowInViewDirection.bottom
    var isShowed = false

    weak var keyView: UIView!
    var backgroundView = UIView()
    var shadowView = UIView()
    var bgEnable = true
    
    var completed: BBShowInViewCompleted?
    var willCompleted: BBShowInViewCompleted?

    public func show(view kView:UIView,
                     keyView kKeyView:UIView){
        show(view: kView,keyView: kKeyView, from: .bottom)
    }
    
    public func show(view kView:UIView,
                     keyView kKeyView:UIView,
                     completed: @escaping BBShowInViewCompleted){
        show(view: kView,keyView: kKeyView, from: .bottom)
        self.completed = completed
    }
    
    //MARK: -- 隐藏
    public func hide(){
        guard let view = view else {
            self.removeSelf()
            return
        }
        
        self.willCompleted?(false)
        
        UIView.animate(withDuration: 0.25, animations: {
            view.frame = self.viewStartFrame
            self.shadowView.alpha = 0.0
        }) {
            _ in
            self.isShowed = false
            view.frame = self.viewEndFrame
            view.removeFromSuperview()
            self.completed?(false)
            self.removeSelf()
        }
    }
    
    func removeSelf() {
        self.backgroundView.removeFromSuperview()
        self.timer?.invalidate()
        BBShowInView.showedSet.remove(self)
    }
    
    deinit {
        print("BBShowInView销毁")
    }
    
    /**
     显示弹框
     - Parameters:
        - view: 需要显示的view
        - keyView: 在哪显示的位置
        - backgroundViewFrame: 背景的frame，为空是keyView的bounds
        - isScrollEnabled: 是否可滚动，默认不可滚动
        - from: 弹出view的方向，top是自上到下
     - Returns
     无
     */
    public func show(view kView: UIView,
                     keyView kKeyView: UIView,
                     backgroundFrame kFrame: CGRect? = nil,
                     from kDirection: BBShowInViewDirection){
        var isSameView = false
        var oldView = self.view
        let oldViewEndFrame = self.viewEndFrame

        if self.view == kView {
            isSameView = true
            oldView = nil
        }
        
        backgroundViewFrame = kFrame ?? kKeyView.bounds
        
        
        isShowed = true
        
        backgroundView.frame = backgroundViewFrame
        kKeyView.addSubview(backgroundView)
        
        view = kView
        keyView = kKeyView

        direction = kDirection
        viewEndFrame = kView.frame
                
        var startFrameX,
            startFrameY,
            startFrameWidth,
            startFrameHeight : CGFloat
        
        let windowFrame = kKeyView.bounds
        
        startFrameX = viewEndFrame.origin.x
        startFrameY = viewEndFrame.origin.y
        startFrameWidth = viewEndFrame.size.width
        startFrameHeight = viewEndFrame.size.height
        
        
        switch direction {
        case .bottom:
            startFrameY = windowFrame.size.height
            
        case .top:
            startFrameY = -viewEndFrame.size.height
            
        case .left:
            startFrameX = -viewEndFrame.size.width
            
        case .right:
            startFrameX = windowFrame.size.width
            
        case .middle:
            startFrameX = windowFrame.size.width * 0.5
            startFrameY = windowFrame.size.height * 0.5
            startFrameWidth = 0.0
            startFrameHeight = 0.0
        }
        
        viewStartFrame = CGRect(x: startFrameX, y: startFrameY, width: startFrameWidth, height: startFrameHeight)
        
        if isSameView {
            kView.frame = oldViewEndFrame
        }else{
            kView.frame = viewStartFrame
        }
        
        backgroundView.addSubview(kView)
        willCompleted?(true)
        
        UIView.animate(withDuration: 0.25, animations: {
            kView.frame = self.viewEndFrame
            oldView?.alpha = 0
            self.shadowView.alpha = 1.0
            
        }) {_ in
            self.completed?(true)
            oldView?.frame = oldViewEndFrame
            oldView?.alpha = 1
            oldView?.removeFromSuperview()
            BBShowInView.showedSet.insert(self)
            self.startTimer()
        }
    }
    
}
