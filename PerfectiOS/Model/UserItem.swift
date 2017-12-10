//
//  UserItem.swift
//  PerfectiOS
//
//  Created by swae on 2017/12/10.
//  Copyright © 2017年 swae. All rights reserved.
//

import Foundation

class UserItem: NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(userId, forKey: "userId")
        aCoder.encode(userName, forKey: "userName")
        aCoder.encode(registerDate, forKey: "registerDate")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        userId = aDecoder.decodeObject(forKey: "userId") as! String
        userName = aDecoder.decodeObject(forKey: "userName") as! String
        registerDate = aDecoder.decodeObject(forKey: "registerDate") as! String
    }
    
    override init() {
        super.init()
    }
    
    
    public var userId: String = ""
    public var userName: String = ""
    public var registerDate: String = ""

}
