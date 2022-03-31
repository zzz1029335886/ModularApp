//
//  BBCommon.swift
//  Common
//
//  Created by zerry on 2022/3/31.
//

import UIKit

/**
 各种回调类型
 */

typealias BBNullCallBack = () -> Void
typealias BBDictionaryCallBack = (_ dict:Dictionary<String, Any>) -> Void
typealias BBAnyCallBack = (_ any:Any) -> Void
typealias BBURLCallBack = (_ url:URL) -> Void
typealias BBBoolURLCallBack = (_ bool:Bool,_ url:URL) -> Void
typealias BBBoolCallBack = (_ bool:Bool) -> Void
typealias BBBoolIntBack = (_ bool:Bool,_ int:Int) -> Void
typealias BBBoolStringCallBack = (_ bool:Bool,_ string:String) -> Void
typealias BBFloatCallBack = (_ float:CGFloat) -> Void
typealias BBIntCallBack = (_ int:Int) -> Void
typealias BBIntFloatCallBack = (_ int:Int, _ float:Float) -> Void
typealias BBStringArrayCallBack = (_ strings:[String]) -> Void
typealias BBStringCallBack = (_ strings:String) -> Void
typealias BBStringIntBack = (_ strings:String,_ int:Int) -> Void

// 屏幕宽度
let kScreenWidth = UIScreen.main.bounds.size.width
// 屏幕高度
let kScreenHeight = UIScreen.main.bounds.size.height

/**
 是否全面屏手机
 */
let kIsFullScreen : Bool = {
    if #available(iOS 11, *) {
          guard let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w else { return false }
          if unwrapedWindow.safeAreaInsets.left > 0 || unwrapedWindow.safeAreaInsets.bottom > 0 { return true }
    }
    return false
}()

/**
 状态栏高度
 */
let kStatusBarHeight : CGFloat = {
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
let kNavigationBarHeight : CGFloat = kStatusBarHeight + 44

/**
 曲面屏底部安全距离
 */
let kBottomSafeHeight : CGFloat = {
    var safeAreaBottom : CGFloat = 0
    if #available(iOS 11, *) {
          if let w = UIApplication.shared.delegate?.window,
             let unwrapedWindow = w {
            safeAreaBottom = unwrapedWindow.safeAreaInsets.bottom
          }
    }
    return safeAreaBottom
}()

let kTabBarHeight : CGFloat = kBottomSafeHeight + 49
