//
//  QQValidate.swift
//  qqncp
//
//  Created by zerry on 2018/9/19.
//  Copyright © 2018年 zerry. All rights reserved.
//

import UIKit
import Foundation

public enum QQValidate {
    case none(_: String)
    case email(_: String)
    case phoneNum(_: String)
    case carNum(_: String)
    case username(_: String)
    case password(_: String)
    case nickname(_: String)
    case equal(_: String,_:String)
    case equalTextField(_: UITextField,_:String)

    case URL(_: String)
    case IP(_: String)
    
    var isRight: Bool {
        var predicateStr:String!
        var currObject:String!
        switch self {
        case .none(_):
            return true
        case let .email(str):
            predicateStr = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
            currObject = str
        case let .phoneNum(str):
            predicateStr = "^1[0-9]{10}$"
            //"^((13[0-9])|(15[^4,\\D])|(16[0,0-9])|(17[0,0-9])|(18[0,0-9]))\\d{8}$"
            currObject = str
        case let .carNum(str):
            predicateStr = "^[A-Za-z]{1}[A-Za-z_0-9]{5}$"
            currObject = str
        case let .username(str):
            predicateStr = "^[A-Za-z0-9]{6,20}+$"
            currObject = str
        case let .password(str):
            predicateStr = "^[a-zA-Z0-9]{6,20}+$"
            currObject = str
        case let .nickname(str):
            predicateStr = "^[\\u4e00-\\u9fa5]{4,8}$"
            currObject = str
        case let .URL(str):
            predicateStr = "^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$"
            currObject = str
        case let .IP(str):
            predicateStr = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
            currObject = str
        case let .equal(str1,str2):
            return str1 == str2
            
        case let .equalTextField(textField,str2):
            return textField.text == str2
        }
        
        let predicate = NSPredicate(format: "SELF MATCHES %@" ,predicateStr)
        return predicate.evaluate(with: currObject)
    }
    
    func isError(_ currObject:String) -> Bool {
        var result:Bool = true

        switch self {
        case .none(_):
            result = QQValidate.none(currObject).isRight
        case .email(_):
            result = QQValidate.email(currObject).isRight
        case .phoneNum(_):
            result = QQValidate.phoneNum(currObject).isRight
        case .carNum(_):
            result = QQValidate.carNum(currObject).isRight
        case .username(_):
            result = QQValidate.username(currObject).isRight
        case .password(_):
            result = QQValidate.password(currObject).isRight
        case .nickname(_):
            result = QQValidate.nickname(currObject).isRight
        case .URL(_):
            result = QQValidate.URL(currObject).isRight
        case .IP(_):
            result = QQValidate.IP(currObject).isRight
        case let .equal(str1, _):
            result = QQValidate.equal(str1, currObject).isRight
        case let .equalTextField(textField, _):
            result = QQValidate.equalTextField(textField, currObject).isRight
        }
        return !result
    }
}
