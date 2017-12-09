//
//  DataBaseHelper.swift
//  PerfectDemoPackageDescription
//
//  Created by swae on 2017/12/9.
//

import PerfectMySQL

/// MARK: 数据库信息
let mysql_database = "PerfecDemo"
let table_account = "account_level"

let REQUEST_RESULT_SUCCESS_VALUE: String = "success"
let REQUEST_RESULT_FAILURE_VALUE: String = "failure"
let REQUEST_RESULT_LIST_KEY = "list"
let REQUEST_RESULT_KEY = "result"
let REQUEST_RESULT_MESSAGE_KEY = "Message"


open class DataBaseHelper {

    /// 单例对象
    static let instance = DataBaseHelper.init()
    
    // 数据库名称
    var database_name: String {
        get {
            return mysql_database
        }
    }
    
    // 用于操作数据库的句柄
    var mysql : MySQL!
    
    private init() {
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
    
    deinit {
        
    }
}

class BaseDao {
    let mysql_database = "PerfecDemo"
    
}

class UserDao: BaseDao {
    let tableName = "user"
    
    /// 根据用户名查询用户信息
    ///
    /// - Parameter userName: 用户名
    /// - Returns: 返回JSON数据
    func queryUserInfo(userName: String) -> String? {
        let statement = "select userId, nickname from user where username = '\(userName)'"

        var response: [String: Any] = [REQUEST_RESULT_LIST_KEY: [], REQUEST_RESULT_KEY: REQUEST_RESULT_SUCCESS_VALUE, REQUEST_RESULT_MESSAGE_KEY: ""]
        
        if !DataBaseHelper.instance.mysql.query(statement: statement) {
            response[REQUEST_RESULT_KEY] = REQUEST_RESULT_FAILURE_VALUE
            response[REQUEST_RESULT_MESSAGE_KEY] = "查询失败"
            print("查询失败")
        } else {
            print("查询成功")
            // 在当前会话过程中保存查询结果
            let results = DataBaseHelper.instance.mysql.storeResults()!
            var dic = [String:String]()
            // 创建一个字典数组用于存储结果
            results.forEachRow { row in
                guard let userId = row.first! else {//保存选项表的Name名称字段，应该是所在行的第一列，所以是row[0].
                    return
                }
                dic["userId"] = "\(userId)"
                dic["userName"] = "\(row[1]!)"
            }
            
            response[REQUEST_RESULT_KEY] = REQUEST_RESULT_SUCCESS_VALUE
            response[REQUEST_RESULT_LIST_KEY] = dic
        }
        
        guard let josn = try? response.jsonEncodedString() else {
            return nil
        }
        return josn
    }
    
    /// 由用户名和密码查询用户信息
    ///
    /// - Parameters:
    ///   - userName: 用户名
    ///   - password: 用户密码
    /// - Returns:
    func queryUserInfo(userName: String, password: String) -> String? {
        let statement = "select * from user where nickname='\(userName)' and password='\(password)'"
        
        var response: [String: Any] = [REQUEST_RESULT_LIST_KEY: [], REQUEST_RESULT_KEY: REQUEST_RESULT_SUCCESS_VALUE, REQUEST_RESULT_MESSAGE_KEY: ""]
        
        if !DataBaseHelper.instance.mysql.query(statement: statement) {
            response[REQUEST_RESULT_KEY] = REQUEST_RESULT_FAILURE_VALUE
            response[REQUEST_RESULT_MESSAGE_KEY] = "查询失败"
            print("查询失败")
        } else {
            print("查询成功")
            // 在当前会话过程中保存查询结果
            let results = DataBaseHelper.instance.mysql.storeResults()!
            //因为上一步已经验证查询是成功的，因此这里我们认为结果记录集可以强制转换为期望的数据结果。当然您如果需要也可以用if-let来调整这一段代码。
            
            var dic = [String:String]() //创建一个字典数组用于存储结果
            if results.numRows() == 0 {
                response[REQUEST_RESULT_KEY] = REQUEST_RESULT_FAILURE_VALUE
                response[REQUEST_RESULT_MESSAGE_KEY] = "用户名或密码错误，请重新输入！"
                print("\(statement)用户名或密码错误，请重新输入")
            } else {
                results.forEachRow { row in
                    guard let userId = row.first! else {//保存选项表的Name名称字段，应该是所在行的第一列，所以是row[0].
                        return
                    }
                    dic["userId"] = "\(userId)"
                    dic["userName"] = "\(row[1]!)"
                    dic["registerTime"] = "\(row[3]!)"
                }
                
                response[REQUEST_RESULT_KEY] = REQUEST_RESULT_SUCCESS_VALUE
                response[REQUEST_RESULT_LIST_KEY] = dic
                
            }
        }
        
        guard let josn = try? response.jsonEncodedString() else {
            return nil
        }
        return josn
    }
    
    /// 获取所有用户信息
    func queryAllUserResult() -> String? {
        
        let statement = "SELECT * FROM \(tableName)"
         var response: [String: Any] = [REQUEST_RESULT_LIST_KEY: [], REQUEST_RESULT_KEY: REQUEST_RESULT_SUCCESS_VALUE, REQUEST_RESULT_MESSAGE_KEY: ""]
        if !DataBaseHelper.instance.mysql.query(statement: statement) {
            response[REQUEST_RESULT_KEY] = REQUEST_RESULT_FAILURE_VALUE
            response[REQUEST_RESULT_MESSAGE_KEY] = "查询失败"
            print("查询失败")
        } else {
            print("查询成功")
            // 在当前会话过程中保存查询结果
            let results = DataBaseHelper.instance.mysql.storeResults()!
            
            if results.numRows() == 0 {
                response[REQUEST_RESULT_KEY] = REQUEST_RESULT_FAILURE_VALUE
                response[REQUEST_RESULT_MESSAGE_KEY] = "无结果"
            }
            else {
                var resultArray = [Dictionary<String, String>]()
                results.forEachRow(callback: { (row) in
                    var dic = [String:String]()
                    let id = row[0]
                    let userName = row[1]
                    let password = row[2]
                    let userId = row[3]
                    if let id = id {
                        dic.updateValue(id, forKey: "id")
                    }
                    if let userName = userName {
                        dic.updateValue(userName, forKey: "userName")
                    }
                    if let password = password {
                        dic.updateValue(password, forKey: "password")
                    }
                    if let userId = userId {
                        dic.updateValue(userId, forKey: "userId")
                    }
                    
                    resultArray.append(dic)
                })
                
                response.updateValue(resultArray, forKey: REQUEST_RESULT_LIST_KEY)
            }
        }
        
        

        guard let json = try? response.jsonEncodedString() else {
            return nil;
        }
        
        return json
    }
    

    /// insert user info
    ///
    /// - Parameters:
    ///   - userName: 用户名
    ///   - password: 密码
    func insertUserInfo(userName: String, password: String) -> String? {
        let values = "('\(userName)', '\(password)')"
        let statement = "insert into \(tableName) (nickname, password) values \(values)"
        print("执行SQL:\(statement)")
        var response: [String: Any] = [REQUEST_RESULT_LIST_KEY: [], REQUEST_RESULT_KEY: REQUEST_RESULT_SUCCESS_VALUE, REQUEST_RESULT_MESSAGE_KEY: ""]
        if !DataBaseHelper.instance.mysql.query(statement: statement) {
            print("\(statement)插入失败")
            response[REQUEST_RESULT_KEY] = REQUEST_RESULT_FAILURE_VALUE
            response[REQUEST_RESULT_MESSAGE_KEY] = "创建\(userName)失败"
            guard let josn = try? response.jsonEncodedString() else {
                return nil
            }
            return josn
        } else {
            print("插入成功")
            return queryUserInfo(userName: userName, password: password)
        }
    }
    
}

class ContentDao: BaseDao {
    let tableName = "note"
    
    /// 添加比较
    ///
    /// - Parameters:
    ///   - userId: 用户ID
    ///   - title: 标题
    ///   - content: 内容
    /// - Returns: 返回结果JSON
    func addContent(userId: String, title: String, content: String) -> String? {
        let values = "('\(userId)', '\(title)', '\(content)')"
        let statement = "insert into \(tableName) (userID, title, content) values \(values)"
        print("执行SQL:\(statement)")
        
        var response: [String: Any] = [REQUEST_RESULT_LIST_KEY: [], REQUEST_RESULT_KEY: REQUEST_RESULT_SUCCESS_VALUE, REQUEST_RESULT_MESSAGE_KEY: ""]
        
        if !DataBaseHelper.instance.mysql.query(statement: statement) {
            print("\(statement)插入失败")
            response[REQUEST_RESULT_KEY] = REQUEST_RESULT_FAILURE_VALUE
            response[REQUEST_RESULT_MESSAGE_KEY] = "创建\(title)失败"
        } else {
            print("插入成功")
            response[REQUEST_RESULT_KEY] = REQUEST_RESULT_SUCCESS_VALUE
        }
        
        guard let josn = try? response.jsonEncodedString() else {
            return nil
        }
        return josn
    }
    
    
    /// 查询Note列表
    ///
    /// - Parameter userId: 用户ID
    /// - Returns: 返回JSON
    func queryContentList(userId: String) -> String? {
        let statement = "select id, title, content, create_time from \(tableName) where userID='\(userId)'"
        print("执行SQL:\(statement)")
        var response: [String: Any] = [REQUEST_RESULT_LIST_KEY: [], REQUEST_RESULT_KEY: REQUEST_RESULT_SUCCESS_VALUE, REQUEST_RESULT_MESSAGE_KEY: ""]
        if !DataBaseHelper.instance.mysql.query(statement: statement) {
            response[REQUEST_RESULT_KEY] = REQUEST_RESULT_FAILURE_VALUE
            response[REQUEST_RESULT_MESSAGE_KEY] = "查询失败"
            print("\(statement)查询失败")
        } else {
            print("SQL:\(statement)查询成功")
            
            // 在当前会话过程中保存查询结果
            let results = DataBaseHelper.instance.mysql.storeResults()! //因为上一步已经验证查询是成功的，因此这里我们认为结果记录集可以强制转换为期望的数据结果。当然您如果需要也可以用if-let来调整这一段代码。
            
            var ary = [[String:String]]() //创建一个字典数组用于存储结果
            if results.numRows() == 0 {
                print("\(statement)尚没有录入新的Note, 请添加！")
            } else {
                results.forEachRow { row in
                    var dic = [String:String]() //创建一个字典用于存储结果
                    dic["contentId"] = "\(row[0]!)"
                    dic["title"] = "\(row[1]!)"
                    dic["content"] = "\(row[2]!)"
                    dic["time"] = "\(row[3]!)"
                    ary.append(dic)
                }
                response[REQUEST_RESULT_LIST_KEY] = ary
            }
            response[REQUEST_RESULT_KEY] = REQUEST_RESULT_SUCCESS_VALUE
        }
        guard let josn = try? response.jsonEncodedString() else {
            return nil
        }
        return josn
    }
    
    
    /// 查询Note详情
    ///
    /// - Parameter contentId: 内容ID
    /// - Returns: 返回相关JOSN
    func queryContentDetail(contentId: String) -> String? {
        let statement = "select content from \(tableName) where id='\(contentId)'"
        print("执行SQL:\(statement)")
        var response: [String: Any] = [REQUEST_RESULT_LIST_KEY: [], REQUEST_RESULT_KEY: REQUEST_RESULT_SUCCESS_VALUE, REQUEST_RESULT_MESSAGE_KEY: ""]
        if !DataBaseHelper.instance.mysql.query(statement: statement) {
            response[REQUEST_RESULT_KEY] = REQUEST_RESULT_SUCCESS_VALUE
            response[REQUEST_RESULT_MESSAGE_KEY] = "查询失败"
            print("\(statement)查询失败")
        } else {
            print("SQL:\(statement)查询成功")
            
            // 在当前会话过程中保存查询结果
            let results = DataBaseHelper.instance.mysql.storeResults()!
            
            var dic = [String:String]() //创建一个字典数于存储结果
            if results.numRows() == 0 {
                response[REQUEST_RESULT_KEY] = REQUEST_RESULT_FAILURE_VALUE
                response[REQUEST_RESULT_MESSAGE_KEY] = "获取Note详情失败！"
                print("\(statement)获取Note详情失败！")
            } else {
                results.forEachRow { row in
                    guard let content = row.first! else {
                        return
                    }
                    dic["content"] = "\(content)"
                }
                
                response[REQUEST_RESULT_KEY] = REQUEST_RESULT_SUCCESS_VALUE
                response[REQUEST_RESULT_LIST_KEY] = dic
            }
        }
        
        guard let josn = try? response.jsonEncodedString() else {
            return nil
        }
        return josn
    }
    
    
    /// 更新内容
    ///
    /// - Parameters:
    ///   - contentId: 更新内容的ID
    ///   - title: 标题
    ///   - content: 内容
    /// - Returns: 返回结果JSON
    func updateContent(contentId: String, title: String, content: String) -> String? {
        let statement = "update \(tableName) set title='\(title)', content='\(content)', create_time=now() where id='\(contentId)'"
        print("执行SQL:\(statement)")
        
        var response: [String: Any] = [REQUEST_RESULT_LIST_KEY: [], REQUEST_RESULT_KEY: REQUEST_RESULT_SUCCESS_VALUE, REQUEST_RESULT_MESSAGE_KEY: ""]
        
        if !DataBaseHelper.instance.mysql.query(statement: statement) {
            response[REQUEST_RESULT_KEY] = REQUEST_RESULT_FAILURE_VALUE
            response[REQUEST_RESULT_MESSAGE_KEY] = "更新失败"
            print("\(statement)更新失败")
        } else {
            print("SQL:\(statement) 更新成功")
            response[REQUEST_RESULT_KEY] = REQUEST_RESULT_SUCCESS_VALUE
        }
        
        guard let josn = try? response.jsonEncodedString() else {
            return nil
        }
        return josn
    }
    
    
    /// 删除内容
    ///
    /// - Parameter contentId: 删除内容的ID
    /// - Returns: 返回删除结果
    func deleteContent(contentId: String) -> String? {
        let statement = "delete from \(tableName) where id='\(contentId)'"
        print("执行SQL:\(statement)")
        var response: [String: Any] = [REQUEST_RESULT_LIST_KEY: [], REQUEST_RESULT_KEY: REQUEST_RESULT_SUCCESS_VALUE, REQUEST_RESULT_MESSAGE_KEY: ""]
        if !DataBaseHelper.instance.mysql.query(statement: statement) {
            response[REQUEST_RESULT_KEY] = REQUEST_RESULT_FAILURE_VALUE
            response[REQUEST_RESULT_MESSAGE_KEY] = "删除失败"
            print("\(statement)删除失败")
        } else {
            print("SQL:\(statement) 删除成功")
            response[REQUEST_RESULT_KEY] = REQUEST_RESULT_SUCCESS_VALUE
        }
        
        guard let josn = try? response.jsonEncodedString() else {
            return nil
        }
        return josn
    }

}
