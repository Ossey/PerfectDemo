//
//  HttpRequestHelper.swift
//  PerfectiOS
//
//  Created by swae on 2017/12/10.
//  Copyright © 2017年 swae. All rights reserved.
//

import UIKit
import Alamofire

// 网络请求超时时间
let NetworkTimeoutInterval:Double = 10

@objc protocol HttpRequestDelegate: NSObjectProtocol {
    
    @objc optional func httpRequestDidSuccess(request: AnyObject?, requestName: String, parameters: NSDictionary?)
    
    @objc optional func httpRequestDidFailure(request: AnyObject?, requestName: String, parameters: NSDictionary?, error: Error)
}

class HttpRequestHelper: NSObject {

    static var sessionManager: SessionManager? = nil
    public var delegate: HttpRequestDelegate?
    
    
    /// 网络请求，闭包回调的方式
    ///
    /// - Parameters:
    ///   - method: 请求方式，get、post..
    ///   - url: 请求的url，可以是String，也可以是URL
    ///   - parameters: 请求参数
    ///   - finishedCallBack: 完成请求的回调
    class func request(method: HTTPMethod, url: String, parameters: NSDictionary?, finishedCallBack: @escaping (_ result: AnyObject?, _ _error: Error?) -> ()) {
        
        let config:URLSessionConfiguration = URLSessionConfiguration.default
        
        config.timeoutIntervalForRequest = NetworkTimeoutInterval
        
        sessionManager = SessionManager(configuration: config)
        
        Alamofire.request(url, method: method, parameters: parameters as? Parameters).responseJSON
            { (response) in
                let data = response.result.value
                if (response.result.isSuccess)
                {
                    finishedCallBack(data as AnyObject, nil)
                }
                else
                {
                    finishedCallBack(data as AnyObject,response.result.error)
                }
        }
        
    }
    
    
    /// 网络请求，代理回调方式
    ///
    /// - Parameters:
    ///   - method: 请求方式，get、post..
    ///   - url: 请求的url，可以是String，也可以是URL
    ///   - requestName: 请求名字，一个成功的代理方法可以处理多个请求，所以用requestName来区分具体请求
    ///   - parameters: 请求参数
    ///   - delegate: 代理对象，实现此代理处理请求成功及失败的回调
    class func requestForDelegate(method: HTTPMethod, url: String, requestName: String, parameters: NSDictionary?, delegate: AnyObject) {
        
        let config:URLSessionConfiguration = URLSessionConfiguration.default
        
        config.timeoutIntervalForRequest = NetworkTimeoutInterval
        
        sessionManager = SessionManager(configuration: config)
        
        Alamofire.request(url, method: method, parameters: parameters as? Parameters).responseJSON
            { (response) in
                let data = response.result.value
                if (response.result.isSuccess) {
                    delegate.httpRequestDidSuccess?(request: data as AnyObject, requestName: requestName, parameters: parameters)
                }
                else {
                    delegate.httpRequestDidFailure?(request: data as AnyObject, requestName: requestName, parameters: parameters, error: response.error!)
                    
                }
        }
    }
}
