//
//  SnapKitExtension.swift
//  tdian
//
//  Created by zerry on 2019/8/7.
//  Copyright © 2019 zerry. All rights reserved.
//

import UIKit
import SnapKit

extension ConstraintMaker{
    /**
     等于其他View
     - parameter view: 其他View
     - parameter edgeInsets: 上下左右的间距
     */
    fileprivate func equalTo(_ view:UIView,edgeInsets:UIEdgeInsets) {
        self.top.equalTo(view).offset(edgeInsets.top)
        self.edges.equalTo(UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))
        self.leading.equalTo(view).offset(edgeInsets.left)
        self.trailing.equalTo(view).offset(-edgeInsets.right)
        self.bottom.equalTo(view).offset(-edgeInsets.bottom)
    }
}

extension ConstraintViewDSL{
    /**
     等于父类
     */
    func equalSuper(priority:ConstraintPriority = .required){
        self.equalSuper(.zero,priority: priority)
    }

    /**
     等于父类
     - parameter edgeInsets: 上下左右的间距
     */
    func equalSuper(_ edgeInsets:UIEdgeInsets,priority:ConstraintPriority = .required){
        self.makeConstraints { maker in
            maker.edges.equalTo(edgeInsets).priority(priority)
        }
    }
//    
//    /**
//     等于其他view
//     - parameter view: 其他View
//     */
//    func equalTo(_ view:UIView) {
//        self.equalTo(view, edgeInsets: .zero)
//    }
//
//    /**
//     等于其他view
//     - parameter view: 其他View
//     - parameter edgeInsets: 上下左右的间距
//     */
//    func equalTo(_ view:UIView, edgeInsets:UIEdgeInsets) {
//        self.makeConstraints { (maker) in
//            maker.equalTo(view, edgeInsets: edgeInsets)
//        }
//    }
}

