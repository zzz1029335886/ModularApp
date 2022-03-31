//
//  DateExtension.swift
//  BrainBank
//
//  Created by zerry on 2021/4/1.
//  Copyright © 2021 yoao. All rights reserved.
//

import UIKit

public
extension NSDate{
    
    /// 友好时间
    @objc var friendTime: String{
        return (self as Date).friendTime
    }
}

public
extension Date{
    /// 当前时间
    static var current: Date{
        if #available(iOS 15, *) {
            return Date.now
        } else {
            return Date()
        }
    }
    
    /// 根据出生日期返回年龄的方法
    func toOld() -> Int{
        let currentDate = Date.init()
        //获得当前系统时间与出生日期之间的时间间隔
        let time = currentDate.timeIntervalSince(self)
        let age = time / (3600 * 24 * 365)
        return Int(age)
    }
    
    /// 是否今天
    var isToday: Bool{
        let calendar = NSCalendar.current
        return calendar.isDateInToday(self)
    }
    
    /// 是否昨天
    var isYesterday: Bool{
        let calendar = NSCalendar.current
        return calendar.isDateInYesterday(self)
    }
    
    var currentDateValues: (Int, Int, Int){
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: self)
        
        return (components.year ?? 0, components.month ?? 0, components.day ?? 0)
    }
    
    /// 是否是今年
    var isThisYear: Bool{
        return self.yearValue == Date().yearValue
    }
    
    /// 友好时间
    /// 例：今天 10:10，昨天 10:10，10月10日，2020年10月10日
    var friendTime: String{
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        let date = self
        if date.isThisYear{
            if date.isToday {
                formatter.dateFormat = "HH:mm"
                return "今天 \(formatter.string(from: date))"
            }else if date.isYesterday{
                formatter.dateFormat = "HH:mm"
                return "昨天 \(formatter.string(from: date))"
            } else {
                formatter.dateFormat = "MM月dd"
                return formatter.string(from: date)
            }
        }else{
            formatter.dateFormat = "yyyy年MM月dd"
            return formatter.string(from: date)
        }
    }
    
    var justMonthAndDay: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "MM-dd"
        return formatter.string(from: self)
    }
    
    /// 获取当前 秒级 时间戳 - 10位
    var timeStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }
    
    ///获取上个月
    func previousMonthDate() -> Date? {
        
        let calendar = NSCalendar.current
        var components = calendar.dateComponents([Calendar.Component.year,
                                                  Calendar.Component.month,
                                                  Calendar.Component.day,], from: self)
        components.day = 15
        if components.month == 1 {
            components.month = 12
            guard let year = components.year else {
                return nil
            }
            components.year = year - 1
        }else {
            guard let month = components.month else {
                return nil
            }
            components.month = month - 1
        }
        
        return calendar.date(from: components)
    }
    
    ///获取下个月
    func nextMonthDate() -> Date? {
        
        let calendar = NSCalendar.current
        var components = calendar.dateComponents([Calendar.Component.year,
                                                  Calendar.Component.month,
                                                  Calendar.Component.day,], from: self)
        components.day = 15

        if components.month == 12 {
            components.month = 1
            guard let _ = components.year else {
                return nil
            }
            
            components.year = components.year! + 1
        }else {
            guard let _ = components.month else {
                return nil
            }
            components.month = components.month! + 1

        }
        return calendar.date(from: components)
    }
    
    ///获取这个月的天数
    func daysInMonth() -> Int {
        
        if let range = NSCalendar.current.range(of: Calendar.Component.day, in: Calendar.Component.month, for: self) {
            
            return range.count
        }
        return 0
    }
    
    
    ///获取月份的第一天星期几
    func firstWeekDayInMonth() -> Int {
        
        let calendar = NSCalendar.current
        var components = calendar.dateComponents([Calendar.Component.year,
                                                  Calendar.Component.month,
                                                  Calendar.Component.day,], from: self)
        components.day = 1
        
        guard let firstDay = calendar.date(from: components) else {
            return 1
        }

        guard let num = calendar.ordinality(of: Calendar.Component.weekday, in: Calendar.Component.weekOfMonth, for: firstDay)  else {
            return 1
        }
        
        return num - 1
    }
    
    var yearValue: Int{
        return currentDateValues.0
    }
    var monthValue: Int{
        return currentDateValues.1
    }
    var dayValue: Int{
        return currentDateValues.2
    }
    
    ///年
    func bb_year() -> Int {
        return yearValue
    }
    
    ///月
    func bb_month() -> Int {
        return monthValue
    }
    
    ///天
    func bb_day() -> Int {
        return dayValue
    }
    
    //本月开始日期
    func startOfCurrentMonth() -> Date {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents(
            Set<Calendar.Component>([.year, .month]), from: self)
        let startOfMonth = calendar.date(from: components)!
        return startOfMonth
    }
     
    //本月结束日期
    func endOfCurrentMonth(returnEndTime:Bool = false) -> Date {
        let calendar = NSCalendar.current
        var components = DateComponents()
        components.month = 1
        if returnEndTime {
            components.second = -1
        } else {
            components.day = -1
        }
        let endOfMonth =  calendar.date(byAdding: components, to: startOfCurrentMonth())!
        return endOfMonth
    }
    
    ///获取日期所在周开始时间
    func startOfCurrentWeek() -> Date {
        let calendar = NSCalendar.current

        let components = calendar.dateComponents(

        Set([.yearForWeekOfYear, .weekOfYear]), from: self)

        return calendar.date(from: components)!
    }
}
