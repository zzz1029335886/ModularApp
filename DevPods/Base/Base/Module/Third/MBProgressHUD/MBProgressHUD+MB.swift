//
//  MBProgressHUD+MB.swift
//  MovieBox
//
//  Created by zerry on 2020/7/10.
//  Copyright © 2020年 zerry. All rights reserved.
//

import UIKit
import MBProgressHUD

class BBProgressHudManager: NSObject, MBProgressHUDDelegate {
    static var shared = BBProgressHudManager()
    
    var showedSet = Set<MBProgressHUD>()
    
    public func hudWasHidden(_ hud: MBProgressHUD) {
        showedSet.remove(hud)
    }
    
    override init() {
        super.init()
        
        UIActivityIndicatorView.appearance(whenContainedInInstancesOf: [MBProgressHUD.self]).color = .white
    }
}

public
extension MBProgressHUD {
    
    /**
     显示提示HUD（菊花）
     - parameter string: 内容
     - parameter icon: 图标
     - parameter view: 显示的位置
     
     - returns
     返回HUD实例
     */
    @discardableResult
    class func showMessage(_ string: String? = nil,
                           view: UIView? = nil)
        -> MBProgressHUD?
    {
        var view = view
        
        if view == nil {
            view = UIApplication.shared.windows.first
        }
        guard let toView = view else { return nil }
        
        let manager = BBProgressHudManager.shared
        
        let hud = MBProgressHUD.showAdded(to: toView, animated: true)
        hud.delegate = manager
        
        hud.label.text = string
        hud.label.textColor = .white
        
        hud.bezelView.style = .solidColor
        hud.bezelView.color = .black
        
        hud.removeFromSuperViewOnHide = true
        
        BBProgressHudManager.shared.showedSet.insert(hud)
        
        return hud
    }
    
    /**
     隐藏HUD
     */
    class func hideMessage(_ view: UIView? = nil) {
        DispatchQueue.main.async {
            if let view = view {
                MBProgressHUD.hide(for: view, animated: true)
            }else{
                hideAllMessage()
            }
        }
    }
    
    /**
     隐藏全部HUD
     */
    class func hideAllMessage() {
        DispatchQueue.main.async {
            BBProgressHudManager.shared.showedSet.forEach { (hud) in
                hud.hide(animated: true)
            }
        }
    }
    
    /**
     显示提示HUD（非菊花）
     - parameter string: 内容
     - parameter icon: 图标
     - parameter view: 显示的位置
     
     - returns
     返回HUD实例
     
     */
    @discardableResult
    public class func show(_ string: String,
                    icon: String?,
                    view: UIView? = nil,
                    afterDelay: TimeInterval = 1)
        -> MBProgressHUD?
    {
        var view = view
        if view == nil {
            view = UIApplication.shared.windows.first
        }
        
        guard let toView = view else { return nil }
        let hud = MBProgressHUD.showAdded(to: toView, animated: true)
        
        hud.label.text = string
        hud.isUserInteractionEnabled = false
        
        if let icon = icon {
            hud.customView = UIImageView.init(image: UIImage.init(named: icon))
            hud.mode = .customView
        }else{
            hud.mode = .text
        }
        
        hud.label.textColor = .white
        hud.label.numberOfLines = 0
        hud.bezelView.style = .solidColor
        hud.bezelView.backgroundColor = .black

        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: afterDelay)
        
        return hud
    }
    
    /**
    显示成功的HUD
    - parameter string: 内容
    - parameter view: 显示的位置
    */
    class func showSuccess(_ string: String,
                           view: UIView? = nil,
                           afterDelay: TimeInterval = 1){
        DispatchQueue.main.async {
            self.show(string, icon: "MBProgressHUD+MB.bundle/success.png", view: view, afterDelay: afterDelay)
        }
    }
    
    /**
    显示失败的HUD
    - parameter string: 内容
    - parameter view: 显示的位置
    */
    class func showError(_ string: String,
                         view: UIView? = nil,
                         afterDelay: TimeInterval = 1){
        DispatchQueue.main.async {
            self.show(string, icon: "MBProgressHUD+MB.bundle/error.png", view: view, afterDelay: afterDelay)
        }
    }
    
    /**
    显示消息的HUD
    - parameter string: 内容
    - parameter view: 显示的位置
    */
    class func showText(_ string: String,
                        view: UIView? = nil,
                        afterDelay: TimeInterval = 1){
        DispatchQueue.main.async {
            self.show(string, icon: nil, view: view, afterDelay: afterDelay)
        }
    }
    
    
}
