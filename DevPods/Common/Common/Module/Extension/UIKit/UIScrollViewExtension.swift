//
//  UIScrollViewExtension.swift
//  BrainBank
//
//  Created by zerry on 2021/4/19.
//  Copyright © 2021 yoao. All rights reserved.
//

import UIKit

extension UIScrollView{
    
    /// 添加一组水平方向的子view，contentSize的宽度是最后一个view的training
    /// - Parameter subViews: 子view列表
    /// - Parameter margin: 水平间距
    /// - Parameter edgeInset: scrollView额外的上下左右的边距
    func addHorizontalSubViews(_ subViews: [UIView],
                               margin: CGFloat,
                               edgeInset: UIEdgeInsets) {
        zz_setupSubViews(subViews, .showType(.horizontal), .verticalSpace(margin), .insetsModel(insets: .with(edgeInsets: edgeInset)))
//        m.height.equalTo(view).offset(edgeInset.top + edgeInset.bottom)
//        m.trailing.equalTo(view).offset(edgeInset.right)
    }
    
    /// 添加一组垂直方向的子view，
    /// scrollView的宽度与contentSize的高度为最后一个view的宽度与bottom
    /// - Parameter subViews: 子view列表
    /// - Parameter margin: 垂直间距
    /// - Parameter edgeInset: scrollView额外的上下左右的边距
    func addVerticalSubViews(_ subViews: [UIView],
                               margin: CGFloat,
                               edgeInset: UIEdgeInsets) {
        zz_setupSubViews(subViews, .showType(.vertical), .verticalSpace(margin), .insetsModel(insets: .with(edgeInsets: edgeInset)))
//        m.width.equalTo(view).offset(edgeInset.left + edgeInset.right)
//        m.bottom.equalTo(view).offset(edgeInset.bottom)
    }
    
    var isReachTop: Bool{
        var top: CGFloat
        if #available(iOS 11.0, *) {
            top = self.adjustedContentInset.top
        } else {
            top = 0
        }
        
        return self.contentOffset.y + top <= 0
    }
    
    var adjustContentInset: UIEdgeInsets{
        if #available(iOS 11.0, *) {
            return self.adjustedContentInset
        } else {
            return .zero
        }
    }
    
}
