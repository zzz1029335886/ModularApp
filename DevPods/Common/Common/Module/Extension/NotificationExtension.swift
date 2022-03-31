//
//  NotificationExtension.swift
//  BrainBank
//
//  Created by zerry on 2021/2/23.
//  Copyright © 2021 yoao. All rights reserved.
//

/**
 通知扩展
 */
extension Notification.Name {
    /// 用户修改信息的通知
    static let UserChangeProfileNotificationKey = Notification.Name(rawValue:"UserChangeProfileNotificationKey")
    /// 切换TanBar的通知
    static let UserChangeTabBarItemKey = Notification.Name(rawValue:"UserChangeTabBarItemKey")
    /// 倒计时的通知名
    static let BBCountDownNotificationKey = Notification.Name(rawValue:"BBCountDownNotification")
    static let USexTypeDidChange = NSNotification.Name("USexTypeDidChange")
    static let tabbarSelect = NSNotification.Name("tabbarSelect")
    static let UserDidLogoutNotificationKey = Notification.Name(rawValue: "UserDidLogoutNotificationKey")
    
    /// 返回问答首页并是否跳转到最新问题
    static let BackAskAnswerHomeAndToAsk = Notification.Name(rawValue: "BackAskAnswerHomeAndToAsk")
    
    static let DeliveryListChanged = Notification.Name(rawValue:"DeliveryListChanged")
    
    static let Calendar_pullDown_Notification = Notification.Name(rawValue:"Calendar_pullDown_Notification")
}
