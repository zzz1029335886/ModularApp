//
//  UIFontExtension.swift
//  BrainBank
//
//  Created by zerry on 2021/1/21.
//  Copyright © 2021 yoao. All rights reserved.
//

import UIKit

public
extension UIFont{
    class var defaultFont:UIFont {
        get{
            return UIFont.defaultFont(14)
        }
    }
    
    class func defaultFont(_ ofSize:CGFloat) -> UIFont{
        return UIFont.regular(ofSize)
    }
    
    class func regular(_ ofSize:CGFloat) -> UIFont{
        return UIFont.systemFont(ofSize: ofSize, weight: UIFont.Weight.regular)
    }
    
    class func thin(_ ofSize:CGFloat) -> UIFont{
        return UIFont.systemFont(ofSize: ofSize, weight: UIFont.Weight.thin)
    }
    
    class func medium(_ ofSize:CGFloat) -> UIFont{
        return UIFont.systemFont(ofSize: ofSize, weight: UIFont.Weight.medium)
    }
    
    class func semiBold(_ ofSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: ofSize, weight: .semibold)
    }
    
    class func helvetica(_ ofSize:CGFloat) -> UIFont{
        return UIFont.init(name: "Helvetica-Bold", size: ofSize)!
    }
}
