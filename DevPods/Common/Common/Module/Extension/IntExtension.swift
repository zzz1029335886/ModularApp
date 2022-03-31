//
//  IntExtension.swift
//  BrainBank
//
//  Created by zerry on 2021/4/14.
//  Copyright © 2021 yoao. All rights reserved.
//

import UIKit

extension Int{
    func minMaxValue(min minValue: Int? = nil,
                     max maxValue: Int? = nil) -> Int {
        var value = self
        
        if let minValue = minValue {
            value = value > minValue ? value : minValue
        }
        
        if let maxValue = maxValue {
            value = value < maxValue ? value : maxValue
        }
        
        return value
    }
    
    /// 时长
    var duration: String {
        return durationString()
    }
    
    /// 小数点后如果只是0，显示整数，如果不是，显示原来的值
    var cleanZero : String {
        return Float(self).cleanZero
    }
    
    var bbPrice: String{
        return Float(self).bbPrice
    }
    
    /// 时长字符串
    /// - Parameter showHourWhenNull: 当'时'为0是，是否显示
    /// - Returns: 00:00 字符串
    func durationString(_ showHourWhenNull: Bool = false) -> String{
        let second = self % 60
        let minute = self / 60 % 60
        let hour = self / 60 / 60 % 60
        
        var values = [minute, second]
        
        if showHourWhenNull {
            values.insert(hour, at: 0)
        } else if (hour != 0) {
            values.insert(hour, at: 0)
        }
        
        let result = values.compactMap {
            (e) -> String in
            return String.init(format: "%02d", e)
        }
        
        return result.joined(separator: ":")
    }
    
    
    func getShortNumberText(_ preStr: String = "W") -> String {
        if self >= 10000 {
            return String(format: "%.2f", CGFloat(self) / 10000).doubleValue.cleanZero + preStr
        } else {
            return "\(self)"
        }
    }
    
    /// 获取总时长
    func getStrWithTime() -> String {
        let hour = self / 3600
        let minute = (self % 3600) / 60
        let second  = self % 60
        if hour > 0 {
            return String(format:"%02d:%02d:%02d", hour, minute, second)
        }else{
            return String(format:"%02d:%02d", minute, second)
        }
    }
    
    
    /// 精确计算金额
    /// - Parameters:
    ///   - scale: 保留几位小数
    ///   - roundingMode: 计算方式
    func dividingMoney(scale: Int16 = 2, roundingMode: NSDecimalNumber.RoundingMode = .bankers)  -> String {
        guard self > 0 else { return String(self) }
        let dec = NSDecimalNumber(value: self)
        let dec1 = NSDecimalNumber(value: 100)
        let decimalNumberHandler = NSDecimalNumberHandler(roundingMode: roundingMode, scale: scale, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        let number = dec.dividing(by: dec1, withBehavior: decimalNumberHandler)
        return String(describing: number)
    }
}

extension Float {
    var bbPrice: String{
        return (self/100).cleanZero
    }
    
    /// 小数点后如果只是0，显示整数
    /// 如果不是，显示原来的值
    var getCleanZero : String {
        if self.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", self)
        }
        
        if self.truncatingRemainder(dividingBy: 0.1) == 0 {
            return String(format: "%.1f", self)
        }
        
        if self.truncatingRemainder(dividingBy: 0.01) == 0 {
            return String(format: "%.2f", self)
        }
        
        return String(self)
    }
    
    /// 小数点后如果只是0，显示整数，如果不是，显示原来的值
    var cleanZero : String {
        return getCleanZero
    }
}

extension CGFloat {
    var bbPrice: String{
        return (self * 0.01).cleanZero
    }
    
    
}

extension Double {
    /// 小数点后如果只是0，显示整数，如果不是，显示原来的值
    var cleanZero : String {
        return Float(self).cleanZero
    }
    
    var bbPrice: String{
        return (self * 0.01).cleanZero
    }
    
    var priceDecimal: String{
        return String.init(format: "%.2lf", self).doubleValue.cleanZero
    }
}

extension String{
    /// 最多小数后两位的字符串
    var priceDecimal: String{
        return self.doubleValue.priceDecimal
    }
}
