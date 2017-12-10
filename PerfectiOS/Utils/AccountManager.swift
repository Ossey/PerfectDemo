//
//  AccountManager.swift
//  PerfectiOS
//
//  Created by swae on 2017/12/10.
//  Copyright © 2017年 swae. All rights reserved.
//

import UIKit

class AccountManager: NSObject {
    
    public var loginUser: UserItem? {
        set {
            
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue as Any)
            UserDefaults.standard.setValue(data, forKey: LoginUserInfoKey)
            UserDefaults.standard.synchronize()
        }
        get {
            guard let data = UserDefaults.standard.value(forKey: LoginUserInfoKey) as? Data else {
                return nil
            }
            
            guard let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? UserItem else {
                return nil
            }
            
            return user
        }
    }
    
    static let shared: AccountManager = AccountManager()
    
}
