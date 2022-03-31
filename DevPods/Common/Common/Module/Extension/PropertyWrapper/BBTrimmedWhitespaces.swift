//
//  BBTrimmedWhitespaces.swift
//  BrainBank
//
//  Created by zerry on 2021/5/27.
//  Copyright © 2021 yoao. All rights reserved.
//

import UIKit

@propertyWrapper
/// 空格修饰注解
struct BBTrimmedWhitespaces {
    private(set) var value = ""
    
    var wrappedValue: String{
        get{
            value
        }
        set{
            value = newValue.trimmingCharacters(in: .whitespaces)
        }
    }
    
    init(wrappedValue initialValue: String) {
        self.wrappedValue = initialValue
    }
    
}
