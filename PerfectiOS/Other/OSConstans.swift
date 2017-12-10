//
//  OSConstans.swift
//  PerfectiOS
//
//  Created by swae on 2017/12/9.
//  Copyright © 2017年 swae. All rights reserved.
//

import Foundation

// 存储登录用户信息的key，如果此key获取的value为nil则说明用户未登录
let LoginUserInfoKey = "LoginUserInfoKey"
let HTTPRequestBaseURLString = "http://localhost:9999"


struct OSConstans {
    static var animationDuration: Double {
        get {
            return 0.36
        }
    }
    
    
    struct HttpRequestURL {
        // 测试
        let account = "\(HTTPRequestBaseURLString)" + "/account"
        // 登录
        let login = "\(HTTPRequestBaseURLString)" + "/login"
        // 注册
        let register = "\(HTTPRequestBaseURLString)" + "/register"
        let queryUserInfoByUserID = "\(HTTPRequestBaseURLString)" + "/queryUserInfoByUserID"
        // moment列表
        let momentList = "\(HTTPRequestBaseURLString)" + "/momentList"
        
    }
    
}
