//
//  TimerExtension.swift
//  BrainBank
//
//  Created by zerry on 2021/4/12.
//  Copyright © 2021 yoao. All rights reserved.
//

extension Timer {
    static func bb_scheduledTimer(with interval: TimeInterval,
                                  repeat isRepeat: Bool,
                                  block: @escaping (Timer) -> Void) -> Timer {
        
        return self.scheduledTimer(timeInterval: interval,
                                   target: self,
                                   selector: #selector(start),
                                   userInfo: block,
                                   repeats: isRepeat)
    }
    
    @objc static func start(_ timer: Timer) {
        let block = timer.userInfo as? ((Timer) -> Void)
        block?(timer)
    }
}
