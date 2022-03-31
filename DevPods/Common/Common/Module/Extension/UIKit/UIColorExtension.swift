//
//  UIColorExtension.swift
//  BrainBank
//
//  Created by zerry on 2021/1/19.
//  Copyright © 2021 yoao. All rights reserved.
//

import UIKit

enum BBGradientChangeDirection : Int {
    /// 水平方向渐变
    case level
    /// 垂直方向渐变
    case vertical
    /// 主对角线方向渐变
    case upwardDiagonalLine
    /// 副对角线方向渐变
    case downDiagonalLine
}

extension UIColor {
    
    convenience init(rgb: UInt, alpha: CGFloat = 1) {
        self.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgb & 0x0000FF) / 255.0, alpha: alpha)
    }
    
    /// 返回随机颜色
    open class var randomColor: UIColor{
        get{
            let red = CGFloat(arc4random() % 256) / 255.0
            let green = CGFloat(arc4random() % 256) / 255.0
            let blue = CGFloat(arc4random() % 256) / 255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
    
    /// 色值转化
    class func hex(hexString: String) -> UIColor {
        return self.hex(hexString: hexString, alpha: 1.0)
    }

    class func hex(hexString: String, alpha: CGFloat) -> UIColor {
        var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        if cString.count < 6 { return UIColor.black }
        
        let index = cString.index(cString.endIndex, offsetBy: -6)
        let subString = cString[index...]
        if cString.hasPrefix("0X") { cString = String(subString) }
        if cString.hasPrefix("#") { cString = String(subString) }
        
        if cString.count != 6 { return UIColor.black }
        
        var range: NSRange = NSMakeRange(0, 2)
        let rString = (cString as NSString).substring(with: range)
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(r: CGFloat(r), g: CGFloat(g), b: CGFloat(b), alpha: alpha)
    }
    
    /// 渐变色
    class func bm_colorGradientChange(
        with size: CGSize,
        direction: BBGradientChangeDirection,
        start startcolor: UIColor?,
        end endColor: UIColor?
    ) -> UIColor {
        return .init(with: size, direction: direction, colors: [startcolor, endColor].compactMap{ $0?.cgColor })
    }
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat) {
        self.init(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: alpha)
    }
    
    convenience init(
        with size: CGSize,
        direction: BBGradientChangeDirection,
        colors: [CGColor]
    ) {
        var size = size
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        var startPoint = CGPoint.zero
        var endPoint = CGPoint.zero
        
        if direction == .downDiagonalLine {
            startPoint = CGPoint(x: 0.0, y: 1.0)
        }
        gradientLayer.startPoint = startPoint
        
        switch direction {
        case .level:
            endPoint = CGPoint(x: 1.0, y: 0.0)
        case .vertical:
            size.height += 1
            endPoint = CGPoint(x: 0.0, y: 1.0)
        case .upwardDiagonalLine:
            endPoint = CGPoint(x: 1.0, y: 1.0)
        case .downDiagonalLine:
            endPoint = CGPoint(x: 1.0, y: 0.0)
        }
        
        gradientLayer.endPoint = endPoint
        gradientLayer.colors = colors
        
        UIGraphicsBeginImageContext(size)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.init(patternImage: image ?? UIImage())
    }
    
    /// 生成图片
    /// - Parameter size: 图片尺寸，默认1像素
    /// - Returns: 图片
    func toImage(size: CGSize = CGSize(width: 1, height: 1)) -> UIImage?{
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        if let context = UIGraphicsGetCurrentContext(){
            context.setFillColor(self.cgColor)
            context.fill(rect)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 高亮颜色
    var highlight : UIColor{
        get{
            if self.responds(to: #selector(getRed(_:green:blue:alpha:))){
                var toRed: CGFloat = 0
                var toGreen: CGFloat = 0
                var toBlue: CGFloat = 0
                var toAlpha: CGFloat = 0
                self.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
                /// 当为1时白色，变灰
                return UIColor.init(red: min(0.9, toRed), green: min(0.9, toGreen), blue: min(0.9, toBlue), alpha: toAlpha * 0.8)
            }
            return self
        }
    }
    
    /// 不可用颜色
    var disable : UIColor{
        get{
            if var (toRed, toGreen, toBlue, toAlpha) = getRgba {
                toRed += 10/255
                toGreen += 10/255
                toBlue += 10/255
                toAlpha += 10/255
                return UIColor.init(red: toRed, green: toGreen, blue: toBlue, alpha: toAlpha)
            }
            return self
        }
    }
    
    /// 设置颜色透明度
    /// - Parameter alpha: 透明度
    /// - Returns: 新颜色
    func alpha(_ alpha: CGFloat) -> UIColor{
        if let (toRed, toGreen, toBlue, toAlpha) = getRgba {
            return UIColor.init(red: toRed, green: toGreen, blue: toBlue, alpha: toAlpha * alpha)
        }
        return self
    }
    
    /// 获取颜色的rgba值
    var getRgba: (CGFloat, CGFloat, CGFloat, CGFloat)?{
        get{
            if self.responds(to: #selector(getRed(_:green:blue:alpha:))){
                var toRed: CGFloat = 0
                var toGreen: CGFloat = 0
                var toBlue: CGFloat = 0
                var toAlpha: CGFloat = 0
                self.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
                return (toRed, toGreen, toBlue, toAlpha)
            }
            return nil
        }
    }
    
    /// 评价颜色
    /// - Parameter colors: 颜色数组
    /// - Returns: 返回的颜色
    static func average(_ colors: [UIColor]) -> UIColor {
            var red = CGFloat.zero
            var green = CGFloat.zero
            var blue = CGFloat.zero
            var alpha = CGFloat.zero
            var count = 0
            
            for color in colors{
                if let res = color.getRgba{
                    red += res.0
                    green += res.1
                    blue += res.2
                    alpha += res.3
                    count += 1
                }
            }
            
            return UIColor(red: red / CGFloat(count), green: green / CGFloat(count), blue: blue / CGFloat(count), alpha: alpha / CGFloat(count))
        }
    
}

func rgba(_ r: CGFloat,
          _ g: CGFloat,
          _ b: CGFloat,
          _ alpha: CGFloat) -> UIColor {
    return UIColor(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: alpha)
}



