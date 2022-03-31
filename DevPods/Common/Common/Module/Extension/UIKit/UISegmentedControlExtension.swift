//
//  UISegmentedControlExtension.swift
//  BrainBank
//
//  Created by zerry on 2021/9/1.
//  Copyright © 2021 yoao. All rights reserved.
//

import UIKit

extension UISegmentedControl {
    /// 自定义样式
    /// - Parameters:
    ///   - normalColor: 普通状态下背景色
    ///   - selectedColor: 选中状态下背景色
    ///   - dividerColor: 选项之间的分割线颜色
    func setSegmentStyle(
        normalBackgroundColor: UIColor,
        selectedBackgroundColor: UIColor
    ) {
        let dividerColor = selectedBackgroundColor
        
        let normalColorImage = UIImage.initFromColor(normalBackgroundColor, size: CGSize(width: 1.0, height: 1.0))
        let selectedColorImage = UIImage.initFromColor(selectedBackgroundColor, size: CGSize(width: 1.0, height: 1.0))
        let dividerColorImage = UIImage.initFromColor(dividerColor, size: CGSize(width: 1.0, height: 1.0))
        
        setBackgroundImage(normalColorImage, for: .normal, barMetrics: .default)
        setBackgroundImage(selectedColorImage, for: .selected, barMetrics: .default)
        setDividerImage(dividerColorImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
}
