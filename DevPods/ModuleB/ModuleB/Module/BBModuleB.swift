//
//  BBModuleA.swift
//  Alamofire
//
//  Created by zerry on 2022/3/31.
//

import UIKit
import Common

public
class BBModuleB: NSObject, ModuleRegister {
    public var register: Common.ModuleBuilder{
        return Common.ModuleBuilder()
    }
    
    public static var bundle: Bundle = .init(for: BBModuleB.self)
    

}
