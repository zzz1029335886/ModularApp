//
//  NSAttributedStringExtension.swift
//  BrainBank
//
//  Created by Joker on 2021/3/16.
//  Copyright © 2021 yoao. All rights reserved.
//

import UIKit

extension NSAttributedString {
    /// 获取带有不同样式的文字内容
    /// - Parameters:
    ///   - stringArray: 字符串数组
    ///   - attributeAttay: 样式数组
    static func addAttribute(_ stringArray: [String],
                             _ attributeAttay: [[NSAttributedString.Key : Any]]) -> NSAttributedString {
        let string = stringArray.joined()
        let result = NSMutableAttributedString.init(string: string)
        
        var loc = 0
        
        for (index,value) in stringArray.enumerated() {
            //            if index == 0 {
            //                loc = 0
            //            }else{
            //                loc = loc + value.count
            //            }
            result.setAttributes(attributeAttay [safe: index], range: .init(location: loc, length: value.count))
            loc = loc + value.count
        }
        return NSAttributedString.init(attributedString: result)
    }
    
    /// 计算文本高度
    /// - Parameters:
    ///   - lineWidth: 每行宽度
    ///   - numberOfLines: 行数，0表示实际高度
    ///   - placeHolder: 占位文字
    /// - Returns: 高度
    func calculateTextHeight(_ lineWidth: CGFloat,
                             numberOfLines: Int,
                             placeHolder: NSAttributedString
    ) -> CGFloat {
        var height: CGFloat = 0.0
        let content = self
        let textSize = content.boundingRect(with: CGSize.init(width: lineWidth,
                                                              height: CGFloat.greatestFiniteMagnitude),
                                            options: [.usesLineFragmentOrigin],
                                            context: nil)
        if numberOfLines == 0 {
            height = textSize.height
        } else {
            let rowH = placeHolder.size().height
            let totalLines = lroundf(Float(textSize.height / rowH))
            if numberOfLines > totalLines {
                height = max(textSize.height, CGFloat(totalLines) * rowH)
            }else{
                height = CGFloat(numberOfLines) * rowH
            }
        }
        height = ceil(height)
        return height
    }
    
}
