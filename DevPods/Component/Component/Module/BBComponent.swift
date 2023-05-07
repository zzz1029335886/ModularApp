//
//  BBComponent.swift
//  Alamofire
//
//  Created by zerry on 2022/4/8.
//

import UIKit
import Common

public
class BBComponent: NSObject, ModuleRegister {
    public var register: Common.ModuleBuilder{
        return Common.ModuleBuilder()
    }
    
    
    public static var bundle = Bundle.init(for: BBComponent.self)
}
