//
//  BBModuleA.swift
//  Alamofire
//
//  Created by zerry on 2022/3/31.
//

import UIKit
import Common
import ObjectiveC

public
class BBModuleB: NSObject, ModuleRegister {
    public var controllerBuilders: [Common.ModuleBuilder.ControllerBuilder]?
    
    public var funcBuilders: [Common.ModuleBuilder.FuncBuilder]? = [
        .register(name: "B", builder: { params in
            return "This is ModuleB"
        })
    ]
    
    
    public var viewBuilders: [ModuleBuilder.ViewBuilder]? = [
        .register(name: "B", builder: { frame in
            return BView()
        })
    ]
    
    public static var bundle: Bundle = .init(for: BBModuleB.self)
    

}
