//
//  BBModuleA.swift
//  Alamofire
//
//  Created by zerry on 2022/3/31.
//

import UIKit
import Common

public
class BBModuleA: NSObject, ModuleRegister {
    
    
    public var register: Common.ModuleBuilder{
        return Common.ModuleBuilder(controllerBuilders: [.register(name: "A", builder: {
            return BBModuleAViewController()
        })])
    }
    
    func ss() -> UIViewController {
        return BBModuleAViewController()
    }
    
    public static var bundle = Bundle.init(for: BBModuleA.self)
}

extension UIImage{
    
    convenience init?(inModuleNamed: String) {
        self.init(named: inModuleNamed, in: BBModuleA.bundle, compatibleWith: nil)
    }
}
