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
    public var register: Common.ModuleRegister{
        return Common.ModuleRegister()
    }
    
    
    public static var bundle = Bundle.init(for: BBComponent.self)
}
