//
//  DataBaseConnect.swift
//  PerfectServerPackageDescription
//
//  Created by swae on 2017/12/9.
//

/// MARK: 数据库信息
let mysql_host = "127.0.0.1"
let mysql_port = "3306"
let mysql_user = "root"
let mysql_password = "root"

import PerfectMySQL


/// 连接MySql数据库的类
class DataBaseConnect {
    /// 数据库的ip地址
    var host: String {
        get {
            return mysql_host
        }
    }
    
    /// 数据库的端口号
    var port: String {
        get {
            return mysql_port
        }
    }
    
    /// 数据库的用户名
    var username: String {
        get {
            return mysql_user
        }
    }
    
    /// 数据库的密码
    var password: String {
        get {
            return mysql_password
        }
    }
    
    /// 用于操作MySql的句柄
    private var connect: MySQL!
    
    /// MySQL句柄单例
    private static var instance: MySQL!
    public static func shareInstance(dataBaseName: String) -> MySQL{
        if instance == nil {
            instance = DataBaseConnect(dataBaseName: dataBaseName).connect
        }
        
        return instance
    }
    
    private init(dataBaseName: String) {
        self.connectDataBase()
        self.selectDataBase(name: dataBaseName)
    }
    
    
    /// 连接数据库
    private func connectDataBase() {
        if connect == nil {
            connect = MySQL()
        }
        
        let connected = connect.connect(host: "\(host)", user: username, password: password)
        guard connected else {// 验证一下连接是否成功
//            LogFile.error(connect.errorMessage())
            print("MySQL连接失败" + connect.errorMessage())
            return
        }
        print("MySQL连接成功")
        
//        LogFile.info("数据库连接成功")
    }
    
    
    /// 选择数据库Scheme
    ///
    /// - Parameter name: Scheme名
    func selectDataBase(name: String){
        // 选择具体的数据Schema
        guard connect.selectDatabase(named: name) else {
//            LogFile.error("数据库选择失败。错误代码：\(connect.errorCode()) 错误解释：\(connect.errorMessage())")
            return
        }
        
//        LogFile.info("连接Schema：\(name)成功")
    }
    
    deinit {
    }
}
