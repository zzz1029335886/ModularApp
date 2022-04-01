//
//  UIButtonExtension.swift
//  BrainBank
//
//  Created by zerry on 2021/3/11.
//  Copyright © 2021 yoao. All rights reserved.
//

import UIKit
import Kingfisher

var expandSizeKey = "expandSizeKey"

public
extension UIButton{
    enum UIButtonImagePosition {
        case top, bottom, left, right
    }
    
    /// 创建纯文字按钮
    /// - Parameters:
    ///   - title: 标题
    ///   - titleColor: 颜色
    ///   - target: 监听者
    ///   - action: 事件
    convenience init(title: String,
                     titleColor: UIColor,
                     titleFont: UIFont?,
                     target: Any? = nil,
                     action: Selector? = nil
                     ){
        self.init()
        bb_setTitle(title, titleColor: titleColor, titleFont: titleFont)
        if let action = action {
            addTarget(target, action: action, for: .touchUpInside)
        }
    }
    
    /// 创建纯图片按钮
    /// - Parameters:
    ///   - imageName: 图片名称
    ///   - imageColor: 图片颜色，可为空
    ///   - target: 监听者
    ///   - action: 事件
    convenience init(imageName: String,
                     imageColor: UIColor? = nil,
                     target: Any? = nil,
                     action: Selector? = nil
                     ){
        self.init()
        bb_setImage(imageName, imageColor: imageColor)
        if let action = action {
            addTarget(target, action: action, for: .touchUpInside)
        }
    }
    
    /// 创建文字图片按钮
    /// - Parameters:
    ///   - title: 标题
    ///   - titleColor: 标题颜色
    ///   - imageName: 图片名称
    ///   - imagePosition: 图片相对按钮位置
    ///   - spacing: 间距
    ///   - target: 监听者
    ///   - action: 事件
    ///   - imageColor: 图片颜色，可为空
    convenience init(title: String,
                     titleColor: UIColor?,
                     titleFont: UIFont?,
                     imageName: String,
                     imageColor: UIColor? = nil,
                     imagePosition: UIButtonImagePosition = .left,
                     spacing: CGFloat = 0,
                     target: Any? = nil,
                     action: Selector? = nil
                     ){
        self.init()
        
        bb_setTitle(title, titleColor: titleColor, titleFont: titleFont)
        bb_setImage(imageName, imageColor: imageColor)
        
        switch imagePosition {
        case .bottom, .top:
            alignVertical(spacing, imageTop: imagePosition == .top)
        case .left, .right:
            alignHorizontal(spacing, imageFirst: imagePosition == .left)
        }
        
        if let action = action {
            addTarget(target, action: action, for: .touchUpInside)
        }
    }
    
    /// 设置title及titleColor
    /// - Parameters:
    ///   - title: 标题
    ///   - titleColor: 标题颜色
    func bb_setTitle(_ title: String?, titleColor: UIColor?, titleFont: UIFont?) {
        setTitle(title, for: .normal)
        titleLabel?.font = titleFont
        
        if let titleColor = titleColor{
            bb_setTitleColor(titleColor)
        }
    }
    
    
    /// 设置图片及图片颜色
    /// - Parameters:
    ///   - imageName: 图片名称
    ///   - imageColor: 图片颜色
    func bb_setImage(_ imageName: String, imageColor: UIColor?) {
        var image = UIImage.init(named: imageName)
        if let imageColor = imageColor {
            image = image?.rechange(color: imageColor)
        }
        setImage(image, for: .normal)
    }
    
    /// 设置文字颜色，同时设置高亮时文字颜色
    /// - Parameter color: 颜色
    func bb_setTitleColor(_ color: UIColor){
        bb_setTitleColor(color, for: UIControl.State.normal)
        bb_setTitleColor(color.highlight, for: UIControl.State.highlighted)
    }
    
    func bb_setTitleColor(_ color: UIColor?, for state: UIControl.State) {
        setTitleColor(color, for: state)
    }
    
    /// 设置背景颜色，同时设置高亮时背景颜色
    /// - Parameter color: 颜色
    func bb_setBackgroundColor(_ color: UIColor){
        setBackgroundImage(UIImage.initFromColor(color), for: UIControl.State.normal)
        setBackgroundImage(UIImage.initFromColor(color.highlight), for: UIControl.State.highlighted)
    }
    
    /// 设置背景颜色，同时设置高亮时背景颜色
    /// - Parameter color: 颜色
    func bb_setBackgroundColor(_ color: UIColor,state:UIControl.State){
        setBackgroundImage(UIImage.imageWithColor(color), for:state)
    }
    
    
    /// 设置垂直方向的按钮
    /// - Parameters:
    ///   - spacing: 图片和文字之间间距
    ///   - imageTop: 是否图片在上
    func alignVertical(_ spacing: CGFloat, imageTop: Bool = true) {
        guard let imageSize = self.imageView?.image?.size,
              let text = self.titleLabel?.text,
              let font = self.titleLabel?.font else {
            return
        }
        
        let labelString = NSString(string: text)
        let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: font])
        
        let imageVerticalOffset = (titleSize.height + spacing) * 0.5
        let titleVerticalOffset = (imageSize.height + spacing) * 0.5
        let imageHorizontalOffset = (titleSize.width) * 0.5
        let titleHorizontalOffset = (imageSize.width) * 0.5
        let sign: CGFloat = imageTop ? 1 : -1
        
        imageEdgeInsets = UIEdgeInsets(top: -imageVerticalOffset * sign,
                                       left: imageHorizontalOffset,
                                       bottom: imageVerticalOffset * sign,
                                       right: -imageHorizontalOffset)
        
        titleEdgeInsets = UIEdgeInsets(top: titleVerticalOffset * sign,
                                       left: -titleHorizontalOffset,
                                       bottom: -titleVerticalOffset * sign,
                                       right: titleHorizontalOffset)
        
        // increase content height to avoid clipping
        let edgeOffset = (min(imageSize.height, titleSize.height) + spacing) * 0.5
        contentEdgeInsets = UIEdgeInsets(top: edgeOffset, left: -titleHorizontalOffset, bottom: edgeOffset, right: -titleHorizontalOffset)
    }
    
    
    /// 设置水平方向的按钮
    /// - Parameters:
    ///   - spacing: 图片和文字之间间距
    ///   - imageFirst: 是否图片在前
    func alignHorizontal(_ spacing: CGFloat, imageFirst: Bool = true) {
        let edgeOffset = spacing * 0.5
        imageEdgeInsets = UIEdgeInsets(top: 0,
                                       left: -edgeOffset,
                                       bottom: 0,
                                       right: edgeOffset)
        titleEdgeInsets = UIEdgeInsets(top: 0,
                                       left: edgeOffset,
                                       bottom: 0,
                                       right: -edgeOffset)
        if !imageFirst {
            self.transform = CGAffineTransform(scaleX: -1, y: 1)
            imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
            titleLabel?.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        
        contentEdgeInsets = UIEdgeInsets(top: 0, left: edgeOffset, bottom: 0, right: edgeOffset)
    }
    
}

extension UIButton {
    /// 扩大按钮响应区域
    open func bb_expandSize(size: CGFloat) {
        objc_setAssociatedObject(self, &expandSizeKey,size, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
    }
    
    private func expandRect() -> CGRect {
        let expandSize = objc_getAssociatedObject(self, &expandSizeKey)
        if (expandSize != nil) {
            return CGRect(x: bounds.origin.x - (expandSize as! CGFloat), y: bounds.origin.y - (expandSize as! CGFloat), width: bounds.size.width + 2*(expandSize as! CGFloat), height: bounds.size.height + 2*(expandSize as! CGFloat))
        }else{
            return bounds;
        }
    }
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let buttonRect =  expandRect()
        if (buttonRect.equalTo(bounds)) {
            return super.point(inside: point, with: event)
        }else{
            return buttonRect.contains(point)
        }
    }
}

// MARK: - 按钮的反复点击问题 交换方法
extension UIButton {
    /// 对外交换方法的方法 AppDelegate Launch中使用
    public static func methodExchange() {
        DispatchQueue.once(token: "UIButton") {
            let originalSelector = Selector.sysFunc
            let swizzledSelector = Selector.myFunc
            changeMethod(originalSelector, swizzledSelector, self)
        }
    }
    
    /// Runtime方法交换
    ///
    /// - Parameters:
    ///   - original: 原方法
    ///   - swizzled: 交换方法
    ///   - object: 对象
    private static func changeMethod(_ original: Selector, _ swizzled: Selector, _ object: AnyClass) -> () {
        
        guard let originalMethod = class_getInstanceMethod(object, original),
              let swizzledMethod = class_getInstanceMethod(object, swizzled) else {
            return
        }
        
        let didAddMethod = class_addMethod(object, original, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        if didAddMethod {
            class_replaceMethod(object, swizzled, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    
    /// 结构体静态key
    private struct UIButtonKey {
        static var isEventUnavailableKey = "isEventUnavailableKey"
        static var eventIntervalKey = "eventIntervalKey"
    }
    
    /// 触发事件的间隔
    var eventInterval: TimeInterval {
        get {
            return (objc_getAssociatedObject(self, &UIButtonKey.eventIntervalKey) as? TimeInterval) ?? 0
        }
        set {
            objc_setAssociatedObject(self, &UIButtonKey.eventIntervalKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// 是否可以触发事件
    fileprivate var isEventUnavailable: Bool {
        get {
            return (objc_getAssociatedObject(self, &UIButtonKey.isEventUnavailableKey) as? Bool) ?? false
        }
        set {
            objc_setAssociatedObject(self, &UIButtonKey.isEventUnavailableKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// 手写的set方法
    /// - Parameter isEventUnavailable: 事件是否不可用
    @objc private func setIsEventUnavailable(_ isEventUnavailable: Bool) {
        self.isEventUnavailable = isEventUnavailable
    }
    
    /// mySendAction
    @objc fileprivate func mySendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        if NSStringFromClass(self.classForCoder) == "UISwipeActionStandardButton"{
            mySendAction(action, to: target, for: event)
        } else if !isEventUnavailable{
            isEventUnavailable = true
            mySendAction(action, to: target, for: event)
            perform(#selector(setIsEventUnavailable(_: )), with: false, afterDelay: eventInterval)
        }
    }
}

fileprivate extension Selector {
    static let sysFunc = #selector(UIButton.sendAction(_:to:for:))
    static let myFunc = #selector(UIButton.mySendAction(_:to:for:))
}

extension DispatchQueue {
    private static var onceTracker = [String]()
    
    open class func once(token: String, block:() -> ()) {
        //注意defer作用域，调用顺序——即一个作用域结束，该作用域中的defer语句自下而上调用。
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        
        if onceTracker.contains(token) {
            return
        }
        onceTracker.append(token)
        block()
    }
}

extension UIButton{
    /**
    设置网络图片
     - parameter urlStr : 图片的网络地址
     - parameter placeholder : 占位图片
     
     */
    func dn_setImage(_ urlStr:String, placeholder: UIImage? = nil, for state: UIControl.State = .normal){
        
        guard let url = URL.init(string: urlStr) else {
            self.setImage(placeholder, for: state)
            return
        }
        let resource = ImageResource.init(downloadURL: url)
        self.kf.setImage(with: resource, for: state)
    }
    
    /**
     设置网络图片
      - parameter urlStr : 图片的网络地址
      - parameter placeholder : 占位图片
      
      */
     func dn_setBackgroundImage(_ urlStr: String, placeholder: UIImage? = nil
         ){
        guard let url = URL.init(string: urlStr) else {
            self.setBackgroundImage(placeholder, for: state)
            return
        }
        
         let resource = ImageResource.init(downloadURL: url)
         self.kf.setBackgroundImage(with: resource, for: .normal)
     }
    
    //MARK: -定义button相对label的位置
    enum RGButtonImagePosition {
        case top          //图片在上，文字在下，垂直居中对齐
        case bottom       //图片在下，文字在上，垂直居中对齐
        case left         //图片在左，文字在右，水平居中对齐
        case right        //图片在右，文字在左，水平居中对齐
    }
    
    /// - Description 设置Button图片的位置
    /// - Parameters:
    ///   - style: 图片位置
    ///   - spacing: 按钮图片与文字之间的间隔
    func imagePosition(style: RGButtonImagePosition, spacing: CGFloat) {
        switch style {
        case .bottom, .top:
            alignVertical(spacing, imageTop: style == .top)
        case .right, .left:
            alignHorizontal(spacing, imageFirst: style == .left)
        }
    }
}
