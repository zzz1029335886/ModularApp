//
//  UINavigationBar+Rainbow.swift
//  Pods
//
//  Created by Danis on 15/11/25.
//
//

import Foundation
import UIKit

private var kRainbowAssociatedKey = "kRainbowAssociatedKey"

public class Rainbow: NSObject {
    class View: UIView {
        
    }
    var navigationBar: UINavigationBar
    
    init(navigationBar: UINavigationBar) {
        self.navigationBar = navigationBar
        
        super.init()
    }
    
    fileprivate var navigationView: UIView?
    fileprivate var statusBarView: UIView?
    
    public var backgroundColor: UIColor? {
        get {
            return navigationView?.backgroundColor
        }
        set {
            if navigationView == nil {
                navigationBar.setBackgroundImage(UIImage(), for: .default)
                navigationBar.shadowImage = UIImage()
                navigationView = Rainbow.View(frame: CGRect(
                    x: 0,
                    y: 0,
                    width: navigationBar.bounds.width,
                    height: navigationBar.bounds.height + UIApplication.shared.statusBarFrame.height
                ))
                
                if let first = navigationBar.subviews.first {
                    navigationView?.frame = first.bounds
                    navigationView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    first.insertSubview(navigationView!, at: 0)
                }
                
                navigationView?.isUserInteractionEnabled = false
            }
            
            if let navigationView = navigationView,
               navigationView.superview == nil,
               let first = navigationBar.subviews.first{
                first.insertSubview(navigationView, at: 0)
            }
            
            navigationView?.backgroundColor = newValue
        }
    }
    public var statusBarColor: UIColor? {
        get {
            return statusBarView?.backgroundColor
        }
        set {
            if statusBarView == nil {
                statusBarView = Rainbow.View(frame: CGRect(x: 0, y: 0, width: navigationBar.bounds.width, height: UIApplication.shared.statusBarFrame.height))
                statusBarView?.isUserInteractionEnabled = false
                statusBarView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                if let navigationView = navigationView {
                    navigationBar.subviews.first?.insertSubview(statusBarView!, aboveSubview: navigationView)
                } else {
                    navigationBar.subviews.first?.insertSubview(statusBarView!, at: 0)
                }
            }
            statusBarView?.backgroundColor = newValue
        }
    }
    public func clear() {
        navigationBar.setBackgroundImage(nil, for: .default)
        navigationBar.shadowImage = nil
        
        navigationView?.removeFromSuperview()
        navigationView = nil
        
        statusBarView?.removeFromSuperview()
        statusBarView = nil
    }
}

extension UINavigationBar {
    public var rb: Rainbow {
        get {
            if let rainbow = objc_getAssociatedObject(self, &kRainbowAssociatedKey) as? Rainbow {
                return rainbow
            }
            let rainbow = Rainbow(navigationBar: self)
            objc_setAssociatedObject(self, &kRainbowAssociatedKey, rainbow, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return rainbow
        }
    }
}
