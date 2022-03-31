//
//  UIEdgeInsetsExtension.swift
//  BrainBank
//
//  Created by zerry on 2021/8/6.
//  Copyright © 2021 yoao. All rights reserved.
//

import CoreGraphics
import UIKit

extension UIEdgeInsets{
    init(
        t: CGFloat = 0,
        l: CGFloat = 0,
        b: CGFloat = 0,
        r: CGFloat = 0
    ) {
        self.init(top: t, left: l, bottom: b, right: r)
    }
    
    init(all: CGFloat) {
        self.init(top: all, left: all, bottom: all, right: all)
    }
    
    init(vertical: CGFloat = 0, horizontal: CGFloat = 0) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
    
    func inset(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> UIEdgeInsets {
        return .init(top: self.top + top, left: self.left + left, bottom: self.bottom + bottom, right: self.right + right)
    }
    
    func inset(insets: UIEdgeInsets) -> UIEdgeInsets {
        return inset(top: insets.top, left: insets.left, bottom: insets.bottom, right: insets.right)
    }
}
