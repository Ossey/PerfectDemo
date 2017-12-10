//
//  Package.swift
//  PerfectTemplate
//
//  Created by Kyle Jessup on 2015-11-05.
//    Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//


/// 软件包管理
import PackageDescription

let versions = Version(0,0,0)..<Version(10,0,0)
let urls = [
    // HTTP服务
    "https://github.com/PerfectlySoft/Perfect-HTTPServer.git",
    // MySql数据库依赖包
    "https://github.com/PerfectlySoft/Perfect-MySQL.git",
    // Mustache
    "https://github.com/PerfectlySoft/Perfect-Mustache.git",
    // 将日志写入到指定log
    //"https://github.com/PerfectlySoft/Perfect-Logger.git",
    // 日志过滤器
    //"https://github.com/dabfleming/Perfect-RequestLogger.git"
]

let package = Package(
    name: "PerfectServer",
    targets: [],
    dependencies: urls.map { .Package(url: $0, versions: versions) }
)

