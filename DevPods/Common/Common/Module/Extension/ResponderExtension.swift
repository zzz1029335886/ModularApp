//
//  ResponderExtension.swift
//  BrainBank
//
//  Created by Joker on 2021/3/9.
//  Copyright © 2021 yoao. All rights reserved.
//

import UIKit

//MARK: -- 在跨多层传递事件时推荐使用，单层传递建议使用delegate，这只是一个便捷方法但并不是偷懒的工具，请勿滥用
struct RouterEventName {
    static let jionMember = "jionMember" //加入会员,此仅为使用范例
    /// 音视频购买（专栏，课程，会员卡）操作
    static let videoPlayBuyAction = "videoPlayBuyAction"
    ///聊天发送常见问题
    static let sendProblem = "sendProblem"
}

extension UIResponder {
    /// 响应链传值
    /// - Parameters:
    ///   - name: 操作名
    ///   - userInfo: 要传递的数据
    /// - Returns: 返回值
    @discardableResult
    @objc func routerEvent(name: String, userInfo: Any?) -> Any?{
        return self.next?.routerEvent(name: name, userInfo: userInfo);
    }
}
