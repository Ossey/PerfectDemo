
# PerfectDemo
> 本示例主要基于Perfect相关组件，使用Swift搭建一个服务器。
Perfect主要包含以下组件。详细查阅
[http://www.infoq.com/cn/news/2015/11/perfect-swift](http://www.infoq.com/cn/news/2015/11/perfect-swift)
PerfectLib
PerfectLib是一个Swift模块，提供了一套进行服务端和客户端开发的核心工具。在许多情况下，客户端和服务端使用相同的API。
Perfect Server
Perfect Server是一个让Perfect能够运转的服务端组件。它是一个始终处于运行状态的独立进程，接受客户端连接、处理请求并返回响应。


- 编译项目
我们使用Apple提供的Package工具(swift的包管理工具)，作用和cocoapods的Podfile类似，目的就是让项目依赖`Package.swift`中的配置
进入PerfectDemo目录下， 执行 `swift build` 编译项目，此时会根据`Package.swift`中的配置clong`Perfect`的某些组件，时间可能会比较久

- 运行项目
如果你没有找到`PerfectDemo.xcodeproj`，你需要执行`swift package generate-xcodeproj`生成，它会根据`Package.swift`中的name属性生成.xcodeproj，然后使用Xcode打开xcodeproj并运行

或者直接执行`.build/debug/PerfectDemo`运行项目

如果运行成功，你可以看到: `[INFO] Starting HTTP server  on 0.0.0.0:9999`


- 创建并连接到MySql


