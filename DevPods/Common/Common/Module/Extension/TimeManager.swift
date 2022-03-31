//
//  TimeManager.swift
//  BrainBank
//
//  Created by Joker on 2021/4/1.
//  Copyright © 2021 yoao. All rights reserved.
//

import UIKit

class TimeManager: NSObject {
    static let share = TimeManager()
    
    lazy var timerContainer = [String : DispatchSourceTimer]()
    
    /// 销毁名字为name的定时器
    /// - Parameter name: 定时器的名字
    func destoryTimer(withName name: String) {
        let timer = timerContainer[name]
        if timer == nil { return }
        timerContainer.removeValue(forKey: name)
        timer?.cancel()
    }
    
    
    /// 检测是否已经存在名字为name的定时器
    ///
    /// - Parameter name: 定时器的名字
    /// - Returns: 返回bool值
    func isExistTimer(withName name: String) -> Bool {
        if timerContainer[name] != nil {
            return true
        }
        return false
    }
    
    
    
    class func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    /// GCD定时器倒计时
    ///
    /// - Parameters:
    ///   - timeInterval: 间隔时间
    ///   - repeatCount: 重复次数
    ///   - handler: 循环事件,闭包参数: 1.timer 2.剩余执行次数
    func dispatchTimer(withName name: String, timeInterval: TimeInterval, repeatCount: Double, handler: @escaping (DispatchSourceTimer?, TimeInterval) -> Void) {
        if repeatCount <= 0 || timeInterval <= 0 { return }
        var timer = timerContainer[name]
        if timer == nil {
            timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
            timer?.resume()
            timerContainer[name] = timer
        }
        var count = timeInterval
        timer?.schedule(deadline: .now(), repeating: repeatCount)
        timer?.setEventHandler { [weak self] in
            guard let `self` = self else { return }
            count -= 1
            DispatchQueue.main.async {
                handler(timer, count)
            }
            if count <= 0 {
                self.destoryTimer(withName: name)
            }
        }
    }
}
