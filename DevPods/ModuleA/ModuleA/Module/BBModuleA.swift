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
    public var controllerBuilders: [Common.ModuleBuilder.ControllerBuilder]? = [
        .register(name: "A", builder: {
            return BBModuleAViewController()
        })
    ]
    
    public var viewBuilders: [Common.ModuleBuilder.ViewBuilder]? = [
        .register(name: "A", builder: { frame in
            if let frame = frame{
                return AView(frame: frame)
            }
            return AView()
            
        })
    ]
    
    public var funcBuilders: [Common.ModuleBuilder.FuncBuilder]? = [
        .register(name: "A", builder: { params in
            return "This is ModuleA"
        })
    ]
    
    
    public override init() {
        
    }
    
    
    
    
    public static var bundle = Bundle.init(for: BBModuleA.self)
}

extension UIImage{
    
    convenience init?(inModuleNamed: String) {
        self.init(named: inModuleNamed, in: BBModuleA.bundle, compatibleWith: nil)
    }
}
