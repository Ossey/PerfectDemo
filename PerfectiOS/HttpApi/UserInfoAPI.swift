//
//  UserInfoAPI.swift
//  PerfectiOS
//
//  Created by swae on 2017/12/10.
//  Copyright © 2017年 swae. All rights reserved.
//

import Foundation

typealias CompletionHandler = (Any?, Error?) -> Void

/// 用户相关接口

// final 关键字定义该类不能被继承
final class UserInfoAPI: NSObject {
    
    static let shared = UserInfoAPI()
    
    private override init() {
        super.init()
    }
    
    
    /// 根据用户id获取用户部分信息
    ///
    /// - Parameters:
    ///   - userId: 用户id
    ///   - handler: 请求完成回调
    func requestUserInfo(userId: String, handler: CompletionHandler?) -> Void {
        
        let urlString = OSConstans.HttpRequestURL().queryUserInfoByUserID
        
        let param: NSDictionary = NSDictionary(object: userId, forKey: "userId" as NSCopying)
        
        HttpRequestHelper.request(method: .post, url: urlString, parameters: param) { (response, error) in
            
            guard let handler = handler else {
                return
            }
            
            if let error = error {
                handler(nil, error)
                return
            }
            
            let user = UserItem()
            guard let userInfos = response as? [String: Any] else {
                handler(nil, nil)
                return
            }
            
            let userInfo = userInfos["list"]
            
            if userInfo != nil {
                guard let userInfo = userInfo as? [String:String] else {
                    handler(nil, nil)
                    return
                }
                user.userId = userInfo["userId"] ?? ""
                user.userName = userInfo["userName"] ?? ""
                user.registerDate = userInfo["registerDate"] ?? ""
                
                handler(user, nil)
            }
        }
    }
    
    func login(userId: String, password: String, handler: CompletionHandler?) -> Void {
        let urlString = OSConstans.HttpRequestURL().login
        
        let parameters = NSDictionary.init(objects: [userId, password], forKeys: ["userId" as NSCopying, "password" as NSCopying])
        
        
        HttpRequestHelper.request(method: .post, url: urlString, parameters: parameters) { (response, error) in
            
            guard let handler = handler else {
                return
            }
            
            if let error = error {
                handler(nil, error)
                return
            }
            
            guard let userInfos = response as? [String: Any] else {
                return
            }
            
            let user = UserItem()
            
            if userInfos["list"] != nil {
                guard let userInfo = userInfos["list"]! as? [String:String] else {
                    handler(nil, nil)
                    return
                }
                
                user.userId = userInfo["userId"] ?? ""
                user.userName = userInfo["userName"] ?? ""
                user.registerDate = userInfo["registerDate"] ?? ""
            }
            
            // 记录当前登录的用户
            AccountManager.shared.loginUser = user
            
            handler(user, nil)
            
        }
    }
    
    
    /// 注册用户请求
    ///
    /// - Parameters:
    ///   - userId: 用户id
    ///   - password: 用户密码
    ///   - handler: 请求完成回调
    func register(userId: String, password: String, userName: String, handler: CompletionHandler?) -> Void {
        let urlString = OSConstans.HttpRequestURL().register
        let parameters = NSDictionary.init(objects: [userId, password, userName, userName], forKeys: ["userId" as NSCopying, "password" as NSCopying, "userName" as NSCopying])
        
        
        HttpRequestHelper.request(method: .post, url: urlString, parameters: parameters) { (response, error) in
            
            guard let handler = handler else {
                return
            }
            
            if let error = error {
                handler(nil, error)
                return
            }
            
            guard let userInfos = response as? [String: Any] else {
                return
            }
            
            let user = UserItem()
            
            if userInfos["list"] != nil {
                guard let userInfo = userInfos["list"]! as? [String:String] else {
                    handler(nil, nil)
                    return
                }
                
                user.userId = userInfo["userId"] ?? ""
                user.userName = userInfo["userName"] ?? ""
                user.registerDate = userInfo["registerDate"] ?? ""
            }
            
            // 记录当前登录的用户
            AccountManager.shared.loginUser = user
            
            handler(user, nil)
            
        }
    }
    

}
