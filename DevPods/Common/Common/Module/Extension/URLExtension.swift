//
//  URLExtension.swift
//  BrainBank
//
//  Created by zerry on 2021/4/9.
//  Copyright © 2021 yoao. All rights reserved.
//

extension URL{
    
    var params: [String: String?]?{
        var components = URLComponents()
        components.query = self.fragment
        if let queryItems = components.queryItems {
            var params : [String: String?] = [:]
            for item in queryItems {
                params[item.name] = item.value
            }
            return params
        }else{
            return nil
        }
        
    }
    
}
