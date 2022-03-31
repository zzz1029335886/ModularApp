//
//  UIViewAnimater.swift
//  BrainBank
//
//  Created by zerry on 2021/5/12.
//  Copyright © 2021 yoao. All rights reserved.
//

import UIKit

struct UIViewAnimater {
    static var timer: Timer?
    static var changeValue: CGFloat = 0
    
    static var count = 50
    static var duration: Double = 0.25
    static var value: CGFloat = 0
    
    /// 特殊动画
    /// - Parameters:
    ///   - duration: 动画时长
    ///   - count: 动画时长内执行次数
    ///   - value: 值
    ///   - animations: 动画过程回调
    ///   - completion: 动画完成回调
    static
    func animate(duration: Double = 0.25,
                 count: Int = 50,
                 value: CGFloat,
                 animations: @escaping ((CGFloat) -> Void),
                 completion: ((Bool) -> Void)? = nil) {
        UIViewAnimater.timer?.invalidate()
        if count <= 0 || duration <= 0{
            return
        }
        let restValue = UIViewAnimater.changeValue * CGFloat(UIViewAnimater.count)

        UIViewAnimater.count = count
        UIViewAnimater.duration = duration
        UIViewAnimater.value = value
        
        let totalValue = value + restValue
        _animate(value: totalValue, animations: animations, completion: completion)
    }
    
    fileprivate static
    func _animate(value: CGFloat,
                  animations: @escaping ((CGFloat) -> Void),
                  completion: ((Bool) -> Void)? = nil
    ) {
        changeValue = value / CGFloat(count)
        let interval: TimeInterval = duration / Double(count)
        
        timer = Timer.bb_scheduledTimer(with: interval, repeat: true) {
            (timer) in
            if count <= 0 {
                complete()
                completion?(true)
                return
            }
            animations(changeValue)
            count -= 1
        }
        timer?.fire()
    }
    
    fileprivate static
    func complete() {
        timer?.invalidate()
        timer = nil
        changeValue = 0
        count = 0
    }
}
