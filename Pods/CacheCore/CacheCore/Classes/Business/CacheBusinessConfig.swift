//
// CacheBusinessConfig.swift
// CacheCore
//
// Created by 柳钰柯 on 2018/4/17.
// Copyright (c) 2018 Larry. All rights reserved.
//

import Foundation
import Moya

private let defaultValidTime: TimeInterval = 24 * 60 * 60
private let defaultLength: Int = 10
//
///*
// * 数据库字段类型
// */
//enum ConfigColumnDataType: String {
//    case typeNull = "NULL"
//    case typeInteger = "INTEGER"
//    case typeReal = "REAL"
//    case typeText = "TEXT"
//    case typeBlob = "BLOB"
//}
//
///*
// * 数据库列字段和数据类型
// */
//struct DBTableConfig {
//    var dataType: ConfigColumnDataType
//    var columnName: String
//
//    init(dataType: ConfigColumnDataType, columnName: String) {
//        self.dataType = dataType
//        self.columnName = columnName
//    }
//}
//
///*
// * 数据库表结构
// */
//struct CacheBusinessTableConfig {
//    var tableStruct: [DBTableConfig]
//    var tableName: String
//
//    init(tableStruct: [DBTableConfig], tableName: String) {
//        self.tableStruct = tableStruct
//        self.tableName = tableName
//    }
//}

//struct Network {
//    var service:MoyaProviderType
//    var httpMethod: HTTPMethod
//
//    init (url: String,method: HTTPMethod,encoding: ParameterEncoding, headers: HTTPHeaders? = nil , parameters: Parameters? = nil) {
//        self.url = url
//        self.httpMethod = method
//        self.headers = headers
//        self.parameters = parameters
//        self.encoding = encoding
//    }
//}

/*
 * 缓存业务配置类
 * validTime: 缓存有效时间
 * table: 数据库表结构
 */
public class CacheBusinessConfig {
    var validTime: TimeInterval
    var length: Int = 10
    var tableName: String
    var keyPath: String?
    
    public init(validTime: TimeInterval, length: Int, tableName: String, keyPath: String? = nil) {
        self.validTime = validTime
        self.tableName = tableName
        self.length = length
        self.keyPath = keyPath
    }
    
    public convenience init(length: Int, tableName: String, keyPath: String? = nil) {
        self.init(validTime: defaultValidTime, length: length, tableName: tableName, keyPath: keyPath)
    }
    
    public convenience init(tableName: String, keyPath: String? = nil) {
        self.init(validTime: defaultValidTime, length: defaultLength, tableName: tableName, keyPath: keyPath)
    }
    
}
