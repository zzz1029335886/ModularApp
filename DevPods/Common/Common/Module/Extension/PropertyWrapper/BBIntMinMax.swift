//
//  BBIntMinMax.swift
//  BrainBank
//
//  Created by zerry on 2021/7/22.
//  Copyright © 2021 yoao. All rights reserved.
//

@propertyWrapper
struct BBIntMinMax {
    var wrappedValue: Int{
        set{
            
            let nValue = newValue
            value = nValue
            
            if let minV = minV {
                value = max(minV, nValue)
            }
            if let maxV = maxV {
                value = min(nValue, maxV)
            }
        }
        get{
            return value
        }
    }
    
    private(set) var value: Int
    
    var minV: Int?
    var maxV: Int?
    
    init(
        wrappedValue initialValue: Int,
        min: Int? = nil,
        max: Int? = nil
    ) {
        self.minV = min
        self.maxV = max
        self.value = initialValue
    }
}

//@propertyWrapper struct RJRange<Type:Comparable> {
//    private var value: Type
//    private var min :Type
//    private var max :Type
//    var wrappedValue:Type {
//        get { value }
//        set {
//            value = (min < newValue) ? (max > newValue ? newValue : max) : min
//        }
//    }
//    
//    init(wrappedValue:Type, min:Type, max:Type) {
//        self.min = min
//        self.max = max
//        value = wrappedValue
//    }
//}
