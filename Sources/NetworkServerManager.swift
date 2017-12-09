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
        // 设置服务端口
        server.serverPort = port
        // 设置根目录
        server.documentRoot = root;
        // 404过滤
        server.setResponseFilters([(Filter404(), .high)])
        
        
    }
    //MARK: 开启服务
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
    
    //MARK: 注册路由
    fileprivate func configure(routes: inout Routes) {
        routes.add(method: .get, uri: "/account") { (request, response) in
            
            let result = DataBaseManager().mysqlGetHomeDataResult()
            let jsonString = self.baseResponseBodyJSONData(status: 200, message: "成功", data: result)
            response.setBody(string: jsonString)
            response.completed()
            
        }
    }
    
    //MARK: 通用响应格式
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
    
    //MARK: 404过滤
    struct Filter404: HTTPResponseFilter {
        
        func filterBody(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
            callback(.continue)
        }
        
        func filterHeaders(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
            if case .notFound = response.status {
                response.setBody(string: "404 文件\(response.request.path)不存在。")
                response.setHeader(.contentLength, value: "\(response.bodyBytes.count)")
                callback(.done)
                
            } else {
                callback(.continue)
            }
        }
        
    }
  
}
