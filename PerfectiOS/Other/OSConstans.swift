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
let BaseURLString = "http://localhost:9999"
let QueryUserInfoByUserID = "/queryUserInfoByUserID"    //通过用户名查询用户信息
let QueryAccount = "/account" // 测试


struct OSConstans {
    static var animationDuration: Double {
        get {
            return 0.36
        }
    }

    
}
