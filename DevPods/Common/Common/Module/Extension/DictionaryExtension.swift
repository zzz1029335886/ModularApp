//
//  DictionaryExtension.swift
//  BrainBank
//
//  Created by Joker on 2021/9/3.
//  Copyright © 2021 yoao. All rights reserved.
//



extension Dictionary {
    ///对象转字符串 有校验值类型方法
    func toJsonString(prettyPrint: Bool = false) -> String? {
        let anyObject = self
        
        if JSONSerialization.isValidJSONObject(anyObject) {
            do {
                let jsonData: Data
                if prettyPrint {
                    jsonData = try JSONSerialization.data(withJSONObject: anyObject, options: [.prettyPrinted])
                } else {
                    jsonData = try JSONSerialization.data(withJSONObject: anyObject, options: [])
                }
                if let str = String(data: jsonData, encoding: .utf8) {
                    return str.replacingOccurrences(of: "\\/", with: "/")
                }
                return String(data: jsonData, encoding: .utf8)
            } catch _ {
                return nil
            }
        } else {
            return nil
        }
    }
    
    ///对象转字符串 无校验值类型方法
    func jsonToString() -> String? {
        /*
         jsonObject->data->string
         */
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: self as Any, options:[])
            if let string = String(data: jsonData, encoding: .utf8) {
                return string.replacingOccurrences(of: "\\/", with: "/")
            }
            return String(data: jsonData, encoding: .utf8)
        }catch{
            print(error)
            return nil
        }
    }
}
