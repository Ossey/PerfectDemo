//
//  DataBaseManager.swift
//  PerfectDemoPackageDescription
//
//  Created by swae on 2017/12/9.
//

import PerfectMySQL

/// MARK: 数据库信息
let mysql_database = "PerfecDemo"
let table_account = "account_level"

open class DataBaseManager {

    // 数据库名称
    var database_name: String {
        get {
            return mysql_database
        }
    }
    
    // 用于操作数据库的句柄
    fileprivate var mysql : MySQL
    
    
    internal init() {
        mysql = DataBaseConnect.shareInstance(dataBaseName: mysql_database)
    }
    
    
    /// MARK: 执行SQL语句
    /// 执行SQL语句
    ///
    /// - Parameter sql: sql语句
    /// - Returns: 返回元组(success:是否成功 result:结果)
    @discardableResult
    func mysqlStatement(_ sql: String) -> (success: Bool, mysqlResult: MySQL.Results?, errorMsg: String) {
        
        guard mysql.selectDatabase(named: mysql_database) else {            // 指定database
            let msg = "未找到\(mysql_database)数据库"
            print(msg)
            return (false, nil, msg)
        }
        
        let successQuery = mysql.query(statement: sql)                      //sql语句
        guard successQuery else {
            let msg = "SQL失败: \(sql)"
            print(msg)
            return (false, nil, msg)
        }
        let msg = "SQL成功: \(sql)"
        print(msg)
        return (true, mysql.storeResults(), msg)//sql执行成功
        
    }
    
    /// 增
    ///
    /// - Parameters:
    /// - tableName: 表
    /// - key: 键  （键，键，键）
    /// - value: 值  ('值', '值', '值')
    func insertDatabaseSQL(tableName: String, key: String, value: String) -> (success: Bool, mysqlResult: MySQL.Results?, errorMsg: String){
        
        let SQL = "INSERT INTO \(tableName) (\(key)) VALUES (\(value))"
        return mysqlStatement(SQL)
        
    }
    
    /// 删
    ///
    /// - Parameters:
    /// - tableName: 表
    /// - key: 键
    /// - value: 值
    func deleteDatabaseSQL(tableName: String, key: String, value: String) -> (success: Bool, mysqlResult: MySQL.Results?, errorMsg: String) {
        
        let SQL = "DELETE FROM \(tableName) WHERE \(key) = '\(value)'"
        return mysqlStatement(SQL)
        
    }
    
    /// 改
    ///
    /// - Parameters:
    /// - tableName: 表
    /// - keyValue: 键值对( 键='值', 键='值', 键='值' )
    /// - whereKey: 查找key
    /// - whereValue: 查找value
    func updateDatabaseSQL(tableName: String, keyValue: String, whereKey: String, whereValue: String) -> (success: Bool, mysqlResult: MySQL.Results?, errorMsg: String) {
        
        let SQL = "UPDATE \(tableName) SET \(keyValue) WHERE \(whereKey) = '\(whereValue)'"
        return mysqlStatement(SQL)
        
    }
    
    /// 查所有
    ///
    /// - Parameters:
    /// - tableName: 表
    /// - key: 键
    func selectAllDatabaseSQL(tableName: String) -> (success: Bool, mysqlResult: MySQL.Results?, errorMsg: String) {
        
        let SQL = "SELECT * FROM \(tableName)"
        return mysqlStatement(SQL)
        
    }
    
    /// 查
    ///
    /// - Parameters:
    /// - tableName: 表
    /// - keyValue: 键值对
    func selectAllDataBaseSQLwhere(tableName: String, keyValue: String) -> (success: Bool, mysqlResult: MySQL.Results?, errorMsg: String) {
        
        let SQL = "SELECT * FROM \(tableName) WHERE \(keyValue)"
        return mysqlStatement(SQL)
        
    }
    
    /// 获取account_level表中所有数据
    func mysqlGetHomeDataResult() -> [Dictionary<String, String>]? {
        
        let result = selectAllDatabaseSQL(tableName: table_account)
        var resultArray = [Dictionary<String, String>]()
        result.mysqlResult?.forEachRow(callback: { (row) in
            var dic = [String:String]()
            let accountLevelId = row[0]
            let name = row[1]
            if let accountLevelId = accountLevelId {
                 dic.updateValue(accountLevelId, forKey: "accountLevelId")
            }
            if let name = name {
                dic.updateValue(name, forKey: "name")
            }
           
            
            resultArray.append(dic)
        })
        return resultArray
        
    }
 
    deinit {
        
    }
}
