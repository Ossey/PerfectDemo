
/// 软件包管理
import PackageDescription

let versions = Version(0,0,0)..<Version(10,0,0)
let urls = [
    /// HTTP服务
    "https://github.com/PerfectlySoft/Perfect-HTTPServer.git",
    /// MySQL服务
    "https://github.com/PerfectlySoft/Perfect-MySQL.git",
    /// Mustache
    "https://github.com/PerfectlySoft/Perfect-Mustache.git"
]

let package = Package(
    name: "PerfectDemo",
    targets: [],
    dependencies: urls.map { .Package(url: $0, versions: versions) }
)

