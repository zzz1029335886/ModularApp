//
//  UIViewNoDataProtocol.swift
//  qqncp
//
//  Created by zerry on 2018/10/18.
//  Copyright © 2018年 zerry. All rights reserved.
//

import UIKit
import SnapKit

private
struct AssociatedKeys {
    static var kRequestErrorAction = "kRequestErrorAction"
    static var kRequestErrorActions = "kRequestErrorActions"
    static var kScrollViewUnderView = "kScrollViewUnderView"
}

extension UIScrollView{
    weak var noDataUnderView: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.kScrollViewUnderView) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.kScrollViewUnderView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension UIView{
    /// 无数据的view
    var noDataView: UIView? {
        return self.getNoDataView(false)
    }
    
    fileprivate
    func createNoDataView() {
        _ = getNoDataView(true)
    }
    
    func showError(_ title: String, titleFont: UIFont = .systemFont(ofSize: 16)) {
        self.showNoData(title: title, titleFont: titleFont, image: nil, buttonTitle: nil, buttonAction: nil)
    }
    
    func showNoData(_ title: String, titleFont: UIFont = .systemFont(ofSize: 16), image: UIImage? = nil) {
        self.showNoData(title: title, titleFont: titleFont, image: image, buttonTitle: nil, buttonAction: nil)
    }
    
    func showNoData(
        title: String,
        titleFont: UIFont = .systemFont(ofSize: 16),
        image: UIImage?,
        buttonTitle: String?,
        buttonAction: BBNullCallBack?) {
            self.showNoData(rect: .zero, title: title, titleFont: titleFont, image: image, buttonTitle: buttonTitle, buttonAction: buttonAction)
        }
    
    func showNoDataCustom(
        rect: CGRect = .zero,
        title: String = "您还没有相关数据哦!",
        titleFont: UIFont = .systemFont(ofSize: 16),
        image: UIImage?,
        createdCustomView: (_ nodataView: UIView, _ customView: UIView) -> Void
    ){
        
        if let scrollView = self as? UIScrollView {
//            scrollView.mj_footer?.isHidden = true
        }
        var frame = rect
        
        if frame == .zero {
            if let scrollView = self as? UIScrollView,
               let underView = scrollView.noDataUnderView{
                let y = underView.frame.maxY
                var height = self.bounds.height - y
                if height <= 100 {
                    scrollView.contentSize.height = max(y + 100, scrollView.contentSize.height)
                    height = 100
                }
                frame = .init(x: 0, y: y, width: self.bounds.width, height: height)
            } else if let tableView = self as? UITableView,
                      let headerView = tableView.tableHeaderView{
                let y = headerView.frame.maxY
                var height = self.bounds.height
                if height == 0 {
                    height = kScreenHeight
                }
                frame = .init(x: 0, y: y, width: self.bounds.width, height: height - y)
            }else if let collectionView = self as? UICollectionView{
                let y = collectionView.contentSize.height
                var height = self.bounds.height - y
                if height <= 100 {
                    collectionView.contentSize.height += 100
                    height = 100
                }
                frame = .init(x: 0, y: y, width: self.bounds.width, height: height)
            }else{
                frame = self.bounds
            }
        }
        
        _ = getNoDataView(false) != nil
        
        guard let noDataView = getNoDataView(true, image:image) else {
            return
        }
        
        guard noDataView.subviews.count > 0 else {
            return
        }
        
        let label = noDataView.viewWithTag(1) as! UILabel
        label.text = title
        label.font = titleFont
        
        self.bringSubviewToFront(noDataView)
        
        noDataView.frame = frame
        if frame.equalTo(self.bounds) {
            noDataView.autoresizingMask = [
                .flexibleWidth,
                .flexibleHeight
            ]
        }else{
            noDataView.autoresizingMask = []
        }
        
        if image != nil, let imageView = noDataView.viewWithTag(2) as? UIImageView {
            imageView.snp.makeConstraints { (m) in
                m.leading.trailing.equalToSuperview()
                m.bottom.equalTo(noDataView.snp.centerY)
            }
            
            label.snp.makeConstraints { (m) in
                m.leading.trailing.equalToSuperview()
                m.top.equalTo(imageView.snp.bottom).offset(10)
                m.height.lessThanOrEqualTo(noDataView.snp_height).multipliedBy(0.5)
            }
            
        }else{
            noDataView.viewWithTag(2)?.removeFromSuperview()
            label.snp.makeConstraints { (m) in
                m.center.equalToSuperview()
                m.leading.equalToSuperview()
            }
        }
        
        noDataView.viewWithTag(3)?.removeFromSuperview()
        noDataView.viewWithTag(4)?.removeFromSuperview()
        
        let customView = UIView()
        customView.tag = 4
        noDataView.addSubview(customView)
        customView.snp.makeConstraints { (m) in
            m.centerX.equalTo(label)
            m.top.equalTo(label.snp.bottom).offset(10)
        }
        noDataView.isUserInteractionEnabled = false
        createdCustomView(noDataView, customView)
    }
    
    func showNoDataWith(
        rect: CGRect = .zero,
        title: String = "您还没有相关数据哦!",
        titleFont: UIFont = .systemFont(ofSize: 16),
        image: UIImage?,
        buttonTitles: [String]?,
        paddingX: CGFloat = 32,
        createdButtons: ([UIButton]) -> Void,
        buttonActions: BBIntCallBack? = nil
    ){
        self.buttonActions = buttonActions
        
        let buttons: [UIButton]
        if let buttonTitles = buttonTitles{
            var index = 0
            buttons = buttonTitles.compactMap {
                buttonTitle -> UIButton in
                let button = createButton(buttonTitle)
                button.tag = index + 100
                index += 1
                button.setTitle("  \(buttonTitle)  ", for: .normal)
                button.addTarget(self, action: #selector(noDataViewButtonClick), for: .touchUpInside)
                return button
            }
        }else{
            buttons = []
        }
        
        showNoDataCustom(rect: rect, title: title, titleFont: titleFont, image: image) {
            (nodataView, view) in
            nodataView.isUserInteractionEnabled = !buttons.isEmpty
            view.addSnpSubViews(
                subViews: buttons,
                countInLine: buttons.count,
                paddingX: paddingX,
                paddingY: paddingX,
                edgeInsets: .zero
            )
            createdButtons(buttons)
        }
        
    }
    
    func showNoData(rect: CGRect = .zero,
                    title: String = "您还没有相关数据哦!",
                    titleFont: UIFont = .systemFont(ofSize: 16),
                    image: UIImage?,
                    buttonTitle: String?,
                    buttonAction: BBNullCallBack? = nil)
    {
        var buttonTitles: [String]? = nil
        if let buttonTitle = buttonTitle {
            buttonTitles = [buttonTitle]
        }
        showNoDataWith(rect: rect, title: title, titleFont: titleFont, image: image, buttonTitles: buttonTitles, paddingX: 0) {
            buttons in
            buttons.first?.superview?.snp.makeConstraints({ m in
                m.height.equalTo(30)
            })
//            buttons.first?.bb_setBackgroundColor(AppCss.themeColor)
            
            buttons.forEach { button in
                button.layer.cornerRadius = 15
                button.clipsToBounds = true
            }
        } buttonActions: { _ in
            buttonAction?()
        }
    }
    
    func hideNoData() {
        if let scrollView = self as? UIScrollView {
//            scrollView.mj_footer?.isHidden = false
        }
        viewWithTag(1994)?.removeFromSuperview()
    }
    
    @objc
    fileprivate
    func noDataViewButtonClick(_ btn: UIButton) {
        self.buttonAction?()
        self.buttonActions?(btn.tag - 100)
    }
    
    fileprivate
    func getNoDataView(_ isCreate: Bool = false) -> UIView? {
        return self.getNoDataView(isCreate, image: nil)
    }
    
    fileprivate
    func getNoDataView(_ isCreate:Bool = false,
                       image: UIImage?) -> UIView? {
        return self.getNoDataView(isCreate,
                                  image:image,
                                  buttonTitle:nil)
    }
    
    fileprivate
    func getNoDataView(_ isCreate:Bool = false,
                       image: UIImage?,
                       buttonTitle:String?) -> UIView? {
        guard let superview = self.superview else {
            return nil
        }
        
        var view = superview.viewWithTag(1994)
        if let view = view {
            if self.next is UIViewController {
                self.addSubview(view)
            } else {
                self.insertSubview(view, at: 0)
            }
            setSubViews(view, image: image, buttonTitle: buttonTitle)
            return view
        }else if isCreate{
            let createdView = UIView.init(frame: .zero)
            createdView.tag = 1994
            if self.next is UIViewController {
                self.addSubview(createdView)
            } else {
                self.insertSubview(createdView, at: 0)
            }
            setSubViews(createdView, image: image, buttonTitle: buttonTitle)
            view = createdView
        }
        
        return view
    }
    
    fileprivate
    func setSubViews(_ createdView: UIView,
                     image: UIImage?,
                     buttonTitle: String?) {
        
        if let image = image, createdView.viewWithTag(2) == nil{
            let imageView = UIImageView.init(frame: .zero)
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            imageView.tag = 2
            createdView.addSubview(imageView)
        }
        
        if let buttonTitle = buttonTitle, createdView.viewWithTag(3) == nil{
            let button = createButton(buttonTitle)
            createdView.addSubview(button)
        }
        
        if createdView.viewWithTag(1) == nil{
            let label = UILabel.init(frame: .zero)
            label.tag = 1
            label.numberOfLines = 0
            label.text = "您还没有相关数据哦!"
            label.textAlignment = .center
            label.textColor = .lightGray
            label.font = UIFont.boldSystemFont(ofSize: 15)
            createdView.addSubview(label)
        }
    }
    
    /// 创建按钮
    /// - Parameter buttonTitle: title
    /// - Returns: 按钮
    fileprivate
    func createButton(_ buttonTitle: String) -> UIButton{
        let button = UIButton.init(frame: .zero)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle(buttonTitle, for: .normal)
//        button.bb_setBackgroundColor(AppCss.themeColor)
        button.bb_setTitleColor(.white, for: .normal)
        return button
    }
}

extension UIView{
    fileprivate
    /// 请求错误后按钮动作
    var buttonAction: BBNullCallBack?{
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.kRequestErrorAction) as? BBNullCallBack
        }
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.kRequestErrorAction, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    fileprivate
    /// 请求错误后按钮动作
    var buttonActions: BBIntCallBack?{
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.kRequestErrorActions) as? BBIntCallBack
        }
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.kRequestErrorActions, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
