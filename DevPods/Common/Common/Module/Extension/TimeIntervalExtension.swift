//
//  TimeIntervalExtension.swift
//  BrainBank
//
//  Created by zerry on 2021/4/15.
//  Copyright © 2021 yoao. All rights reserved.
//

import UIKit

extension TimeInterval{
    var realTime: TimeInterval{
        if self > 4102416000 {
            return self / 1000
        }
        return self
    }
    
    /// 时间戳转化为时间字符串
    func dateFormatString(dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String{
        let date = Date(timeIntervalSince1970: realTime)
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = dateFormat
        return dateformatter.string(from: date)
    }
    
    var friendTime: String{
        return Date(timeIntervalSince1970: realTime).friendTime
    }
    
    var justMonthAndDay: String {
        return Date(timeIntervalSince1970: realTime).justMonthAndDay
    }
    
    /// 计算相隔天数
    func compareInterval(endTime: TimeInterval) -> Int {
        let start = String(self).dateValue
        let end = String(endTime).dateValue
        if Calendar.current.isDate(start, inSameDayAs: end) {
            //同一天
            return 0
        }else {
            //不是同一天
            let components = NSCalendar.current.dateComponents([.day,.hour,.minute,.second], from: start, to: end)
            guard let day = components.day, let hour = components.hour, let minute = components.minute, let second = components.second else {
                return 0
            }
            if hour > 0 || minute > 0 || second > 0 {
                return day + 1
            }
            return day
        }
    }
}
