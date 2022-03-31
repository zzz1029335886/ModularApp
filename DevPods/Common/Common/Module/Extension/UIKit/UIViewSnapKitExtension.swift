//
//  UIViewSnapKitExtension.swift
//  BrainBank
//
//  Created by zerry on 2021/4/20.
//  Copyright © 2021 yoao. All rights reserved.
//

import UIKit
import SnapKit

extension UIView{
    
    /// 使用snp批量设置子视图的约束，最后一个子视图的高度为自己的高度，子控件宽度相同
    /// - Parameters:
    ///   - subViews: 子视图列表
    ///   - countInLine: 每行个数，当每行数量为：1时，效果就是垂直布局
    ///   - paddingX: 横向间距
    ///   - paddingY: 纵向间距
    ///   - edgeInsets: 内边距
    func addSnpSubViews(subViews: [UIView],
                        countInLine: Int = 2,
                        itemHeight: CGFloat? = nil,
                        paddingX: CGFloat = 16,
                        paddingY: CGFloat = 16,
                        edgeInsets: UIEdgeInsets = .zero,
                        lastBottomPriority: ConstraintPriority = .required
    ) {
        zz_setupSubViews(subViews, .showType(.equalSize(countInLine, itemHeight)), .verticalSpace(paddingY), .horizontalSpace(paddingX), .insetsModel(insets: .with(edgeInsets: edgeInsets)), .keyPriority(lastBottomPriority))
    }
    
    
    /// 添加水平带权重的view数组
    /// - Parameters:
    ///   - weights: 权重数组
    ///   - extraWidths: 额外的宽度
    ///   - paddingX: 水平间距
    ///   - edgeInsets: 外边距
    ///   - subViews: views
    func addSnpHorizontalWeightSubViews(
        _ subViews: [UIView],
        weights: [CGFloat],
        extraWidths: [CGFloat],
        paddingX: CGFloat = 16,
        edgeInsets: UIEdgeInsets = .zero
    ) {
        let view = self
        var paddingX1 = paddingX
        
        var leading = view.snp.leading
        var height = view.snp.height
        var top = view.snp.top
        
        let leftMargin: CGFloat = edgeInsets.left
        let topMargin: CGFloat = edgeInsets.top
        let rightMargin: CGFloat = edgeInsets.right
        let bottomMargin: CGFloat = edgeInsets.bottom
        
        var extraWidth: CGFloat = 0
        extraWidths.forEach { value in
            extraWidth += value
        }
        
        var all: CGFloat = 0
        weights.forEach { value in
            all += value
        }
        
        let offset = -(extraWidth + leftMargin + rightMargin + paddingX1 * CGFloat(subViews.count - 1))
        
        for (index, subview) in subViews.enumerated() {
            view.addSubview(subview)
            
            /// 第一个
            if index == 0{
                subview.snp.makeConstraints { (m) in
                    m.leading.equalToSuperview().inset(leftMargin)
                    m.top.equalTo(top).offset(topMargin)
                }
                
                height = subview.snp.height
                leading = subview.snp.trailing
                top = subview.snp.top
                
            }else {
                subview.snp.makeConstraints { (m) in
                    m.height.equalTo(height)
                    m.top.equalTo(top)
                    m.leading.equalTo(leading).offset(paddingX1)
                }
                
                leading = subview.snp.trailing
                top = subview.snp.top
                
                paddingX1 = paddingX
            }
            subview.snp.makeConstraints { (m) in
                m.width.equalToSuperview().multipliedBy(weights[index]/all).offset(offset * weights[index]/all + extraWidths[index])
            }
            
            if index == subViews.count - 1 {
                subview.snp.makeConstraints { (m) in
                    m.bottom.equalToSuperview().inset(bottomMargin)
                }
            }
        }
    }
    
    /// 使用snp批量设置水平子视图，每个之间平均距离相同，并居中
    /// - Parameter subViews: 子视图列表
    /// - Parameter spaceWidth: 间距宽度，不设为自适应
    /// - Parameter edgeInsets: 内边距
    func addSnpHorizontalSubViews(_ subViews: [UIView],
                                  spaceWidth: CGFloat? = nil,
                                  edgeInsets: UIEdgeInsets = .zero) {
        zz_setupSubViews(subViews, .showType(.horizontal), .horizontalSpace(spaceWidth), .insetsModel(insets: .with(edgeInsets: edgeInsets)))
    }
    
    /// 使用snp批量设置垂直子视图，每个之间平均距离相同，并居中
    /// - Parameter subViews: 子视图列表
    /// - Parameter spaceHeight: 间距，不设为自适应
    /// - Parameter edgeInsets: 内边距
    func addSnpVerticalSubViews(_ subViews: [UIView],
                                spaceHeight: CGFloat? = nil,
                                edgeInsets: UIEdgeInsets = .zero) {
        zz_setupSubViews(subViews, .showType(.vertical), .verticalSpace(spaceHeight), .insetsModel(insets: .with(edgeInsets: edgeInsets)))
    }
                            
    
    func getHorizontalSuperView(_ subViews: [UIView],
                                spaceWidth: CGFloat? = nil,
                                edgeInsets: UIEdgeInsets = .zero) -> ZZSnapMutipleViewSetup.FlexView {
        let view = ZZSnapMutipleViewSetup.FlexView()
        view.addSnpHorizontalSubViews(subViews, spaceWidth: spaceWidth, edgeInsets: edgeInsets)
        return view
    }
    
    func getVerticalSuperView(_ subViews: [UIView],
                              spaceHeight: CGFloat? = nil,
                              edgeInsets: UIEdgeInsets = .zero) -> ZZSnapMutipleViewSetup.FlexView {
        let view = ZZSnapMutipleViewSetup.FlexView()
        view.addSnpVerticalSubViews(subViews, spaceHeight: spaceHeight, edgeInsets: edgeInsets)
        return view
    }
}
