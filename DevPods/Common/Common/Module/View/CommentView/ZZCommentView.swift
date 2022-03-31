//
//  ZZCommentTextView.swift
//  CommentTextView
//
//  Created by zerry on 2018/8/1.
//  Copyright © 2018年 zerry. All rights reserved.
//

import UIKit
import Foundation
//import IQKeyboardManagerSwift

protocol ZZCommentViewDelegate:AnyObject {
    func commentViewReturnDidClick(_ commentView: ZZCommentView) -> Bool
    func commentViewTextChanged(_ commentView: ZZCommentView)
    func commentView(_ commentView: ZZCommentView, heightChange height: CGFloat)
}

extension ZZCommentViewDelegate{
    func commentViewTextChanged(_ commentView: ZZCommentView){}
    func commentViewReturnDidClick(_ commentView: ZZCommentView) -> Bool{ return true }
    func commentView(_ commentView: ZZCommentView, heightChange height: CGFloat) { }
}

class ZZCommentView: UIView {
    weak var delegate: ZZCommentViewDelegate?
    var textView: ZZCommentTextView!
    var transformExtHeight: CGFloat = -44
    var indexPath: IndexPath?
    
    init(frame: CGRect = .zero,
         padding: CGFloat = 15,
         hasLine: Bool = true,
         isEffect: Bool = true) {
        super.init(frame: frame)
        
        if isEffect {
            let effect = UIBlurEffect.init(style: .extraLight)
            let effectView = UIVisualEffectView.init(effect: effect)
            effectView.frame = self.bounds
            effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(effectView)
        }
        
        textView = ZZCommentTextView( frame: CGRect(x: padding,
                                                    y: padding * 0.5,
                                                    width: self.frame.width - 2 * padding,
                                                    height: self.frame.height - padding),
                                      placeholder: "请输入信息",
                                      placeholderColor: .lightGray)
        
        textView.returnKeyType = .send
        textView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 2, bottom: 2, right: 2)
        textView.placeholderOrigin = CGPoint.init(x: 8, y: 8)
        textView.kDelegate = self
        textView.contentOffset = .zero
        textView.enablesReturnKeyAutomatically = true
        addSubview(textView)
        
        if hasLine {
            self.setTopLineView()
        }
        
        self.addObserver()
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    deinit {
        self.removeObserver()
    }
    
    @objc func keyboardShow(_ note:Notification) {
        //        IQKeyboardManager.shared.enableAutoToolbar = false
//        IQKeyboardManager.shared.enable = false
        guard let userInfo  = note.userInfo as NSDictionary? else { return }
        guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        guard let durationNumber = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else { return }
        
        let keyBoardBounds = keyboardFrame.cgRectValue
        let duration = durationNumber.doubleValue
        
        UIView.animate(withDuration: duration) {
            self.transform = CGAffineTransform.init(translationX: 0, y: -keyBoardBounds.height - self.frame.height - self.transformExtHeight)
        }
        
    }
    
    @objc func keyboardHide(_ note:Notification) {
//        IQKeyboardManager.shared.enable = true
        guard let userInfo  = note.userInfo as NSDictionary? else { return }
        guard let durationNumber = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else { return }
        let duration = durationNumber.doubleValue
        UIView.animate(withDuration: duration) {
            self.transform = .identity
        }
    }
    
    func resetText() {
        self.textView.text = ""
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        self.textView.resignFirstResponder()
        return super.resignFirstResponder()
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        self.textView.becomeFirstResponder()
        return super.becomeFirstResponder()
    }
    
}

extension ZZCommentView:UITextViewDelegate, ZZCommentTextViewDelegate{
    func commentTextViewTextChanged(_ textView: ZZCommentTextView) {
        
    }
    
    func commentTextViewReturnDidClick(_ textView: ZZCommentTextView) -> Bool {
        if let delegate = self.delegate {
            return delegate.commentViewReturnDidClick(self)
        }
        return true
    }
    
    func commentTextView(_ textView: ZZCommentTextView, heightDidChanged height: CGFloat) {
        self.delegate?.commentView(self, heightChange: height)
        
        UIView.animate(withDuration: 0.25) {
            self.frame.size.height += height
            self.transform = CGAffineTransform.init(translationX: 0, y: self.transform.ty - height)
        }
    }
}
