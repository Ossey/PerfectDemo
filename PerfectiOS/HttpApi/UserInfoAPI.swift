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
    
    func requestUserInfo(accountName: String, handler: CompletionHandler?) -> Void {
        
        let urlString = "\(BaseURLString)\(QueryUserInfoByUserID)"
        
        let param: NSDictionary = NSDictionary(object: accountName, forKey: "userId" as NSCopying)
        
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
}
