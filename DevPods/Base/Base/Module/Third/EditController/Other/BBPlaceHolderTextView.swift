//
//  BBPlaceHolderTextView.swift
//  FreshAllTime
//
//  Created by zerry on 2018/7/26.
//  Copyright © 2018年 蜡笔小姜和畅畅. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol BBPlaceholerTextViewDelegate{
    func placeholerTextViewDidChange(_ placeholerTextView: BBPlaceholerTextView)
    func placeholerTextViewDidEndEditing(_ textView: UITextView)
    func placeholerTextViewDidBeginEditing(_ textView: UITextView)
}

extension BBPlaceholerTextViewDelegate{
    func placeholerTextViewDidEndEditing(_ textView: UITextView){}
    func placeholerTextViewDidBeginEditing(_ textView: UITextView){}
}

class BBPlaceholerTextView: UITextView {
    
    //MARK: - 懒加载属性
    var placeholderLabelPoint = CGPoint.zero{
        didSet{
            placeholderLabel.frame.origin = placeholderLabelPoint
            let insetX = max(0, placeholderLabelPoint.x - 5)
            let insetY = max(0, placeholderLabelPoint.y - 5)
            
            textContainerInset = .init(top: placeholderLabelPoint.y,
                                       left: insetX,
                                       bottom: insetY,
                                       right: insetX)
        }
    }
    lazy var placeholderLabel = UILabel()
    lazy var countLabel = UILabel()
    var kDelegate: BBPlaceholerTextViewDelegate?
    override var text: String?{
        didSet{
            checkShowHiddenPlaceholder()
        }
    }
    //储存属性
    @objc var placeholderGlobal: String?{      //提示文字
        didSet{
            placeholderLabel.text = placeholderGlobal
            placeholderLabel.sizeToFit()
        }
    }
    @objc var placeholderColorGlobal: UIColor?{
        didSet{
            placeholderLabel.textColor = placeholderColorGlobal
        }
    }
    @objc var isReturnHidden: Bool = false     //是否点击返回失去响应
    @objc var isShowCountLabel: Bool = false { //是否显示计算个数的Label
        didSet{
            countLabel.isHidden = !isShowCountLabel
        }
    }
    @objc var limitWords: UInt = 999999             //限制输入个数   默认为999999，不限制输入
    
    //MARK: - 系统方法
    /// PlaceholerTextView 唯一初始化方法
    convenience init(placeholder: String?,
                     placeholderColor: UIColor?,
                     frame: CGRect) {
        self.init(frame: frame)
        setup(placeholder: placeholder, placeholderColor: placeholderColor)
        placeholderGlobal = placeholder
        placeholderColorGlobal = placeholderColor
    }
    
    private override init(frame: CGRect,
                          textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    //XIB 调用
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup(placeholder: nil, placeholderColor: nil)
    }
}

//MARK: - 自定义UI
extension BBPlaceholerTextView{
    
    /// placeholder Label Setup
    func setup(placeholder: String?,
               placeholderColor: UIColor?){
        
        delegate = self
        
        if font == nil {
            font = UIFont.systemFont(ofSize: 14)
        }
        
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.textAlignment = .left
        placeholderLabel.font = font
        placeholderLabel.text = placeholder
        placeholderLabel.sizeToFit()
        if placeholderLabel.frame.width > self.frame.width {
            placeholderLabel.numberOfLines = 0
        }

        placeholderLabel.frame.origin = self.placeholderLabelPoint
        addSubview(placeholderLabel)

        countLabel.font = font
        countLabel.isHidden = isShowCountLabel
        addSubview(countLabel)
    }
}

//MARK: - UITextViewDelegate代理方法
extension BBPlaceholerTextView : UITextViewDelegate{
    func textViewDidEndEditing(_ textView: UITextView) {
        self.kDelegate?.placeholerTextViewDidEndEditing(textView)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.kDelegate?.placeholerTextViewDidBeginEditing(textView)
    }
    
    func textViewDidChange(_ textView: UITextView) {
//        textView.text = removeEmoji(string: textView.text)
        self.kDelegate?.placeholerTextViewDidChange(self)
        
        checkShowHiddenPlaceholder()
        
        guard isShowCountLabel else {
            return
        }
        
//        if self.hasText {
//            countLabel.isHidden = true
//        }else{
//            countLabel.isHidden = false
//        }
        countLabel.text = "\(textView.text.count)/\(limitWords)"
        countLabel.sizeToFit()
        countLabel.frame.origin = CGPoint(x: frame.width-countLabel.frame.width-10, y: frame.height-countLabel.frame.height-5)
    }
    
    // 移除字符串中的表情符号，返回一个新的字符串
//    public func removeEmoji(string: String) -> String {
//        return string.characters.reduce("") {
//            if $1.isEmoji {
//                ProgressHUD.showMessage(message: "暂不支持输入表情")
//                return $0 + ""
//            } else {
//                return $0 + String($1)
//            }
//        }
//    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" && isReturnHidden == true {
            textView.resignFirstResponder()
        }
        
        for char in text {
            if char.isEmoji{
                MBProgressHUD.showText("暂不支持输入表情")
                return false
            }
        }
        
        //大于等于限制字数，而且不是删除键的时候不可以输入。
        if range.location+range.length >= limitWords && !(text as NSString).isEqual(to: ""){
            return false
        }
        
        return true
    }
}

//MARK : - 工具方法

extension BBPlaceholerTextView {
    
    ///根据textView是否有内容显示placeholder
    fileprivate func checkShowHiddenPlaceholder(){
        if self.hasText {
            placeholderLabel.text = nil
        }else{
            placeholderLabel.text = placeholderGlobal
        }
    }
}
