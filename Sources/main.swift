import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

let networkServer = NetworkServerManager(root: "./webroot", port: 9999)
networkServer.startServer()
