//
//  BBStringCalculation.swift
//  qqncp
//
//  Created by zerry on 2018/10/16.
//  Copyright © 2018年 zerry. All rights reserved.
//

import UIKit


/// 字符串数组计算
/// 例：在搜索页面中，搜索历史数组或热词数组，依次从左到右排列，并且自动换行
public struct BBStringCalculation {
    /// 字符串
    var strings : [String]
    
    /// 字体
    var font : UIFont = UIFont.systemFont(ofSize: 17)
    /// 左边距
    var marginLeft : CGFloat = 0
    /// 右边距
    var marginRight : CGFloat = 0
    /// 上边距
    var marginTop : CGFloat = 0
    
    /// 外边距 x轴
    var marginX : CGFloat = 0
    /// 外边距 y轴
    var marginY : CGFloat = 0
    
    /// 内左边距
    var extraWidth : CGFloat = 00
    
    /// 宽度
    var width : CGFloat = BBCommon.kScreenWidth
    /// 每项高度
    var itemHeight : CGFloat = 25
    
    public init(
        strings: [String],
        font: UIFont = .regular(14),
        marginLeft: CGFloat = 0,
        marginRight: CGFloat = 0,
        marginTop: CGFloat = 0,
        marginX: CGFloat = 0,
        extraWidth: CGFloat = 0,
        width: CGFloat = BBCommon.kScreenWidth,
        itemHeight: CGFloat = 25
    ) {
        self.strings = strings
        self.font = font
        self.marginLeft = marginLeft
        self.marginRight = marginRight
        self.marginTop = marginTop
        self.marginX = marginX
        self.extraWidth = extraWidth
        self.width = width
        self.itemHeight = itemHeight
    }
    
    /// 计算
    /// - Returns: 各字符串的frame，行数
    public func calculation() -> ([CGRect], Int) {
        var frames : [CGRect] = []
        
        let attr : [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
        let marginHor = marginX
        let marginVer = marginY
        var lineCount = 0
        let width = self.width - marginLeft - marginRight
        
        for (_,title) in strings.enumerated() {
            
            let lastFrame = frames.last ?? CGRect(x: 0, y: marginTop, width: marginLeft, height: 0)
            
            var x = lastFrame.maxX + (frames.count > 0 ? marginHor : 0)
            var y = lastFrame.minY
            
            var titleSize =  "\(title)".boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin], attributes: attr, context: nil).size
            titleSize.width += extraWidth
            
            if x + titleSize.width > self.width - marginRight{
                x = marginLeft
                y = lastFrame.maxY + marginVer
                lineCount += 1
            }
            
            var itemHeight = self.itemHeight
            if titleSize.height > itemHeight{
                itemHeight = titleSize.height + 5
            }
            
            if titleSize.width < itemHeight{
                titleSize.width = itemHeight
            }
            
            let frame = CGRect(x: x, y: y, width: titleSize.width, height: itemHeight)
            frames.append(frame)
            
        }
        
        return (frames, lineCount)
    }
}
