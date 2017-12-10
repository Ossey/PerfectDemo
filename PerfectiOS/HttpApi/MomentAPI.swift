//
//  MomentAPI.swift
//  PerfectiOS
//
//  Created by swae on 2017/12/10.
//  Copyright © 2017年 swae. All rights reserved.
//

import UIKit

final class MomentAPI: NSObject {

    static let shared = MomentAPI()
    
    private override init() {
        super.init()
    }
    
    public func queryMomentList(userId: String, handler: CompletionHandler?) {
        
        let urlString = OSConstans.HttpRequestURL().momentList
        
        let parameters = NSDictionary.init(object: userId, forKey: "userId" as NSCopying)
        
        HttpRequestHelper.request(method: .post, url: urlString, parameters: parameters) { (response, error) in
            
            guard let handler = handler else {
                return
            }
            
            if let error = error {
                handler(nil, error)
                return
            }
            
            guard let response = response else {
                handler(nil, nil)
                return
            }
            
            guard let list = response["list"] as? [[String:String]] else {
                handler(nil, nil)
                return
            }
            
            var moments: Array<Moment> = []
            
            for item:[String: String] in list {
                let moment = Moment()
                guard let momentId = item["momentId"] else {
                    continue
                }
                moment.momentId = momentId
                
                guard let userId = item["userId"] else {
                    continue
                }
                moment.userId = userId
                
                if let title = item["title"] {
                    moment.title = title
                }
                if let content = item["content"] {
                    moment.content = content
                }
                if let create_time = item["create_time"] {
                    moment.create_time = create_time
                }
                moments.append(moment)
            }
            
            handler(moments, nil)
        }
    }
}
