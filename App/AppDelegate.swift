//
//  AppDelegate.swift
//  App
//
//  Created by zerry on 2022/3/31.
//

import UIKit
import ModuleA
import ModuleB
@_exported import Base
@_exported import Common

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        BBCommon.moduleApp.moduleRegister(register: ModuleA.BBModuleA())
        
//        BBCommon.moduleApp.builderRegister(builder: ModuleBuilder.ControllerBuilder.register(name: "B") {
//            return ModuleB.BBModuleBViewController()
//        })

        window = .init(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = BBTabBarController()
        
        return true
    }


}

