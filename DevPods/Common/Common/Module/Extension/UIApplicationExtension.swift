//
//  UIApplicationExtension.swift
//  BrainBank
//
//  Created by 姜文浩 on 2021/5/17.
//  Copyright © 2021 yoao. All rights reserved.
//

import Foundation
extension UIApplication{
    var statusBarBackgroundColor: UIColor? {
        get {
            if #available(iOS 13.0, *) {
                let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
                return statusBar.backgroundColor
            } else {
                let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
                return statusBar.backgroundColor
            }
        }
        set {
            if #available(iOS 13.0, *) {
                let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
                if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
                    statusBar.backgroundColor = newValue
                }
                UIApplication.shared.keyWindow?.addSubview(statusBar)
            } else {
                let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
                if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
                    statusBar.backgroundColor = newValue
                }
            }
        }
    }
    
    var currentWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            if let window = connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first{
                return window
            }else if let window = UIApplication.shared.delegate?.window{
                return window
            }else{
                return nil
            }
        } else {
            if let window = UIApplication.shared.delegate?.window{
                return window
            }else{
                return nil
            }
        }
    }
}
