//
//  LLRainbowColorSource.swift
//  Pods
//
//  Created by Danis on 15/11/25.
//
//

import UIKit

protocol RainbowColorSource {
    ///  导航栏颜色
    var navigationBarInColor: UIColor { get set }
    /// 导航栏相似颜色，当导航栏颜色为渐变色时，过渡时使用的颜色
    var navigationBarInSimilarColor: UIColor? { get set }
    
    //    @objc optional func navigationBarOutColor() -> UIColor
}

//@objc public protocol RainbowNavigationMutable {
//    @objc optional func currentNavigationBarColor() -> UIColor
//}
