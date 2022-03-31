//
//  AppDelegate.swift
//  App
//
//  Created by zerry on 2022/3/31.
//

import UIKit
//@_exported import Common
@_exported import Base

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = .init(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = BBTabBarController()
        return true
    }


}

