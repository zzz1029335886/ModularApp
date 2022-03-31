//
//  Networking.swift
//  Networking
//
//  Created by zerry on 2022/3/31.
//

import UIKit
import Alamofire
import HandyJSON

public
class BBNetworking: NSObject {
    
    /**
     请求返回继承HandyJSON的对象
     - parameter method: 请求方式post,get等
     - parameter params: 请求对象
     - parameter aClass: 请求返回对象类
     - parameter success: 成功回调，返回请求响应对象类
     - parameter failed: 失败回调，返回失败原因
     
     - returns
     请求实例
     */
    @discardableResult
    public class func handyJSONRequest<T: HandyJSON>(
        _ method: HTTPMethod,
        params: BBNetworkingParams,
        aClass: T.Type,
        success: @escaping (_ result: T) -> Void,
        failed: @escaping (_ error: String) -> Void,
        file: String? = #file,
        function: String? = #function,
        line: Int? = #line
    )
    -> DataRequest?
    {
        return nil
    }
    
    /**
     请求返回继承BBNetworkingResult的对象，并判断returnCode是否为0，0标示成功
     - parameter method: 请求方式post,get等
     - parameter params: 请求对象
     - parameter aClass: 请求返回结果类
     - parameter success: 成功回调
     - parameter result: 参数`aClass`实例
     - parameter failed: 失败回调
     - parameter error: 失败原因
     - returns
     请求实例
     */
    @discardableResult
    public class func resultRequest<T: BBNetworkingResult>(
        _ method: HTTPMethod,
        params: BBNetworkingParams,
        aClass: T.Type,
        success: @escaping (_ result: T) -> Void,
        failed: @escaping (_ error: String) -> Void,
        file: String? = #file,
        function: String? = #function,
        line: Int? = #line
    )
    -> DataRequest?
    {
        return handyJSONRequest(method, params: params, aClass: aClass) {
            result in
            success(result)
        } failed: { error in
            failed(error)
        }
    }
}
