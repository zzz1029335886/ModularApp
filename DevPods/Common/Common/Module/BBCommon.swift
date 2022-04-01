//
//  BBCommon.swift
//  Common
//
//  Created by zerry on 2022/3/31.
//

import UIKit


public struct BBCommon {
    
    /**
     各种回调类型
     */
    public struct CallBack {
        public typealias NullCallBack = () -> Void
        public typealias DictionaryCallBack = (_ dict:Dictionary<String, Any>) -> Void
        public typealias AnyCallBack = (_ any:Any) -> Void
        public typealias URLCallBack = (_ url:URL) -> Void
        public typealias BoolURLCallBack = (_ bool:Bool,_ url:URL) -> Void
        public typealias BoolCallBack = (_ bool:Bool) -> Void
        public typealias BoolIntBack = (_ bool:Bool,_ int:Int) -> Void
        public typealias BoolStringCallBack = (_ bool:Bool,_ string:String) -> Void
        public typealias FloatCallBack = (_ float:CGFloat) -> Void
        public typealias IntCallBack = (_ int:Int) -> Void
        public typealias IntFloatCallBack = (_ int:Int, _ float:Float) -> Void
        public typealias StringArrayCallBack = (_ strings:[String]) -> Void
        public typealias StringCallBack = (_ strings:String) -> Void
        public typealias StringIntBack = (_ strings:String,_ int:Int) -> Void
    }
    
    // 屏幕宽度
    public static let kScreenWidth = UIScreen.main.bounds.size.width
    // 屏幕高度
    public static let kScreenHeight = UIScreen.main.bounds.size.height

    /**
     是否全面屏手机
     */
    public static let kIsFullScreen : Bool = {
        if #available(iOS 11, *) {
              guard let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w else { return false }
              if unwrapedWindow.safeAreaInsets.left > 0 || unwrapedWindow.safeAreaInsets.bottom > 0 { return true }
        }
        return false
    }()

    /**
     状态栏高度
     */
    public static let kStatusBarHeight : CGFloat = {
        var safeAreaTop : CGFloat = 20
        if #available(iOS 11, *) {
              if let w = UIApplication.shared.delegate?.window,
                let unwrapedWindow = w {
                safeAreaTop = unwrapedWindow.safeAreaInsets.top
              }
        }
        return safeAreaTop
    }()

    /**
     导航栏高度
     */
    public static let kNavigationBarHeight : CGFloat = kStatusBarHeight + 44

    /**
     曲面屏底部安全距离
     */
    public static let kBottomSafeHeight : CGFloat = {
        var safeAreaBottom : CGFloat = 0
        if #available(iOS 11, *) {
              if let w = UIApplication.shared.delegate?.window,
                 let unwrapedWindow = w {
                safeAreaBottom = unwrapedWindow.safeAreaInsets.bottom
              }
        }
        return safeAreaBottom
    }()

    public static let kTabBarHeight : CGFloat = kBottomSafeHeight + 49
}

