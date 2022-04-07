//
//  BBModuleA.swift
//  Alamofire
//
//  Created by zerry on 2022/3/31.
//

import UIKit
import Common

public
class BBModuleA: NSObject, ModuleProtocol {
    public static var frameworkBundle = Bundle.init(for: BBModuleA.self)
}

extension UIImage{
    
    convenience init?(inModuleNamed: String) {
        self.init(named: inModuleNamed, in: BBModuleA.frameworkBundle, compatibleWith: nil)
    }
}
