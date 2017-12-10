import PerfectLib
import PerfectHTTPServer
import PerfectHTTP

open class NetworkServerManager {
    fileprivate var server: HTTPServer
    internal init(root: String, port: UInt16) {
        // 创建HTTPServer服务器
        server = HTTPServer.init()
        // 创建路由器
        // Register your own routes and handlers
        var routes = Routes()
  
        // 注册路由
        configure(routes: &routes)
        // 将路由添加到服务
        server.addRoutes(routes)
        // 设置ip地址
        server.serverAddress = "0.0.0.0"
        // 设置服务端口
        server.serverPort = port
        // 设置根目录
        server.documentRoot = root;
        // 404过滤
        server.setResponseFilters([(Filter404(), .high)])
        
        
    }
    // MARK: 开启服务
    open func startServer() {
        
        do {
            print("启动HTTP服务器")
            try server.start()
        } catch PerfectError.networkError(let err, let msg) {
            print("网络出现错误：\(err) \(msg)")
        } catch {
            print("网络未知错误")
        }
        
    }
    
    // MARK: 注册路由
    fileprivate func configure(routes: inout Routes) {
        
        // 根据用户名查询用户ID
        routes.add(method: .post, uri: "/queryUserInfoByUserID") { (request, response) in
            guard let userId: String = request.param(name: "userId") else {
                print("userId为nil")
                return
            }
            guard let json = UserDao().queryUserInfo(userId: userId) else {
                print("userId为nil")
                return
            }
            print(json)
            response.setBody(string: json)
            response.completed()
        }
        
        // 注册
        routes.add(method: .post, uri: "/register") { (request, response) in
            guard let userName: String = request.param(name: "userName") else {
                print("userName为nil")
                return
            }
            
            guard let password: String = request.param(name: "password") else {
                print("password为nil")
                return
            }
            
            guard let userId: String = request.param(name: "userId") else {
                print("userId为nil")
                return
            }
            
            // 注册前先查询，账号是否存在，如果存在则告诉用户，不执行注册
            let json = UserDao().queryUserInfo(userId: userId, password: password)
            if json != nil  {
                response.setBody(string: "用户已存在")
                response.completed()
                return
            }
            
            // 注册
            guard let registerResult = UserDao().insertUserInfo(userName: userName, password: password) else {
                print("registerJosn为nil")
                response.setBody(string: "服务器未返回")
                response.completed()
                return
            }
            print(registerResult)
            response.setBody(string: registerResult)
            response.completed()
        }
        
        // 根据userId和密码登录
        routes.add(method: .post, uri: "/login") { (request, response) in
            guard let userId: String = request.param(name: "userId") else {
                print("userId为nil")
                response.setBody(string: "userId不能为空")
                response.completed()
                return
            }
            guard let password: String = request.param(name: "password") else {
                print("password为nil")
                response.setBody(string: "密码不能为空")
                response.completed()
                return
            }
            guard let json = UserDao().queryUserInfo(userId: userId, password: password) else {
                response.setBody(string: "用户名或密码错误")
                response.completed()
                return
            }
            print(json)
            response.setBody(string: json)
            response.completed()
        }

        // 获取moment列表
        routes.add(method: .post, uri: "/momentList") { (request, response) in
            guard let userId: String = request.param(name: "userId") else {
                print("userId为nil")
                response.setBody(string: "userId不存在")
                response.completed()
                return
            }
            
            guard let json = MomentDao().queryMomentList(userId: userId) else {
                print("josn为nil")
                response.setBody(string: "服务器未返回")
                response.completed()
                return
            }
            print(json)
            response.setBody(string: json)
            response.completed()
        }
        
        // 获取moment详情
        routes.add(method: .post, uri: "/momentDetail") { (request, response) in
            guard let momentId: String = request.param(name: "momentId") else {
                print("momentId为nil")
                return
            }
            guard let json = MomentDao().queryMomentDetail(momentId: momentId) else {
                print("josn为nil")
                response.setBody(string: "服务器未返回")
                response.completed()
                return
            }
            print(json)
            response.setBody(string: json)
            response.completed()
        }
        
        // 发送moment
        routes.add(method: .post, uri: "/sendMoment") { (request, response) in
            guard let userId: String = request.param(name: "userId") else {
                print("userId为nil")
                return
            }
            
            guard let title: String = request.param(name: "title") else {
                print("title为nil")
                return
            }
            
            guard let content: String = request.param(name: "content") else {
                print("content为nil")
                return
            }
            
            guard let json = MomentDao().addMoment(userId: userId, title: title, content: content) else {
                print("josn为nil")
                return
            }
            print(json)
            response.setBody(string: json)
            response.completed()
        }
        
        // 更新moment
        routes.add(method: .post, uri: "/updateMoment") { (request, response) in
            guard let contentId: String = request.param(name: "momentId") else {
                print("momentId为nil")
                return
            }
            
            guard let title: String = request.param(name: "title") else {
                print("title为nil")
                return
            }
            
            guard let content: String = request.param(name: "content") else {
                print("content为nil")
                return
            }
            
            guard let json = MomentDao().updateMoment(momentId: contentId, title: title, content: content) else {
                print("josn为nil")
                return
            }
            print(json)
            response.setBody(string: json)
            response.completed()
        }
        
        // 删除moment
        routes.add(method: .post, uri: "/deleteMoment") { (request, response) in
            guard let momentId: String = request.param(name: "momentId") else {
                print("contentId为nil")
                return
            }
            
            guard let json = MomentDao().deleteMoment(momentId: momentId) else {
                print("josn为nil")
                return
            }
            print(json)
            response.setBody(string: json)
            response.completed()
        }
        
        // 根目录
        routes.add(method: .get, uri: "/", handler: {
            request, response in
            response.setHeader(.contentType, value: "text/html")
            response.appendBody(string: "<html><title>Hello!</title><body><h3>欢迎访问Ossey服务</h3></body></html>")
            response.completed()
        })
        
        // 获取所有用户信息，测试用
        routes.add(method: .get, uri: "/account") { (request, response) in
            
            let result = UserDao().queryAllUserResult()
            response.setBody(string: result!)
            response.completed()
        }
        
        // MARK: - 文件上传
        /// 创建路径用于存储已上传文件
        let fileDir = Dir(Dir.workingDir.path + "files")
        do {
            try fileDir.create()
        } catch {
            print(error)
        }
        
        // 文件上传
        routes.add(method: .post, uri: "/upload") { (request, response) in
            // 通过操作fileUploads数组来掌握文件上传的情况
            // 如果这个POST请求不是分段multi-part类型，则该数组内容为空
            
            if let uploads = request.postFileUploads, uploads.count > 0 {
                // 创建一个字典数组用于检查已经上载的内容
                var ary = [[String:Any]]()
                
                for upload in uploads {
                    ary.append([
                        "fieldName": upload.fieldName,  //字段名
                        "contentType": upload.contentType, //文件内容类型
                        "fileName": upload.fileName,    //文件名
                        "fileSize": upload.fileSize,    //文件尺寸
                        "tmpFileName": upload.tmpFileName   //上载后的临时文件名
                        ])
                    
                    // 将文件转移走，如果目标位置已经有同名文件则进行覆盖操作。
                    let thisFile = File(upload.tmpFileName)
                    do {
                        let _ = try thisFile.moveTo(path: fileDir.path + upload.fileName, overWrite: true)
                    } catch {
                        print(error)
                    }
                }
                print(ary)
            }
        }

        routes.add(method: .delete, uri: "/user") { (request, response) in
            self.requestHandler(request: request, response: response)
        }
    }
    
    func requestHandler(request: HTTPRequest, response:HTTPResponse) {
        response.setBody(string: convertJons(params:request.params()))
        response.completed()
    }
    // MARK: - 获取请求参数:
    func convertJons(params: [(String, String)]) -> String{
        var jsonDic:[String:String] = [:]
        for item in params {
            jsonDic[item.0] = item.1
        }
        
        guard let json = try? jsonDic.jsonEncodedString() else {
            return ""
        }
        
        return json
    }

    
    // MARK: 通用响应格式
    func baseResponseBodyJSONData(status: Int, message: String, data: Any!) -> String {
        
        var result = Dictionary<String, Any>()
        result.updateValue(status, forKey: "status")
        result.updateValue(message, forKey: "message")
        if (data != nil) {
            result.updateValue(data, forKey: "data")
        }else{
            result.updateValue("", forKey: "data")
        }
        guard let jsonString = try? result.jsonEncodedString() else {
            return ""
        }
        return jsonString
        
    }
    
    // MARK: 404过滤（定制404页面）
    struct Filter404: HTTPResponseFilter {
        
        func filterBody(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
            callback(.continue)
        }
        
        func filterHeaders(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
            if case .notFound = response.status {
                response.bodyBytes.removeAll()
                response.setBody(string: "<h1>404:The file \(response.request.path) was not found.</h1>")
                response.setHeader(.contentLength, value: "\(response.bodyBytes.count)")
                callback(.done)
            } else {
                callback(.continue)
            }
        }
        
    }
  
}
