//
// DataBaseSQLUtil.swift
// CacheCore
//
// Created by 柳钰柯 on 2018/4/17.
// Copyright (c) 2018 Larry. All rights reserved.
//

import Foundation
import FMDB

public class DataBaseSQLUtil {
    
    fileprivate var tables = Set<String>()
    
    private func setupTableList(_ database: FMDatabase) {
        if self.tables.count > 0 {
            return
        }
        let sql = "select name from sqlite_master where type='table' order by name;"
        do {
            let rs = try database.executeQuery(sql, values: nil)
            while rs.next() {
                if let table = rs.string(forColumnIndex: 0) {
                    self.tables.insert(table)
                }
            }
        } catch {
            debugPrint("查询数据库表出错")
        }
    }
    
    func createCachedTableWithConfig(_ database: FMDatabase, config: CacheBusinessConfig) -> Bool {
        let sql = "CREATE TABLE IF NOT EXISTS \"\(config.tableName)\"" +
            " (object blob, " +
            "objectID text NOT NULL PRIMARY KEY," +
        "cachedDate text);"
        do {
            try database.executeUpdate(sql, values: nil)
            self.tables.insert(config.tableName)
            return true
        } catch {
            print("创建表\"\(config.tableName)\"失败!")
            return false
        }
    }
    
    func insertCachedDataWithConfig(_ database: FMDatabase, config: CacheBusinessConfig, values: [(Data,String)],callBack: ((_ isSuccess:Bool, _ flag:String?) -> Void)?) {
        if !self.isTableExistWith(database: database, config: config) {
            if !self.createCachedTableWithConfig(database, config: config) { return }
        }
        var dateStr = ""
        for item in values {
            let sql = "replace into \(config.tableName) (object,objectID,cachedDate) values (?,?,?)"
            do {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                dateStr = dateFormatter.string(from: Date())
                try database.executeUpdate(sql, values: [item.0, item.1, dateStr])
            } catch {
                debugPrint("⚠️\(sql)执行错误，插入数据到表\"\(config.tableName)\"中失败!\(#line)")
                callBack?(false,nil)
                return
            }
        }
        callBack?(true,dateStr)
    }
    
    func dataWithConfig(_ database: FMDatabase,
                        config: CacheBusinessConfig,
                        flag: String?,
                        callBack: FetchCachedDataCallBack) {
        if !self.isTableExistWith(database: database, config: config) {
            if !self.createCachedTableWithConfig(database, config: config) { return }
        }
        let sql = flag == nil ?
            "select object,cachedDate from \(config.tableName) order by cachedDate asc limit \(config.length)" :
        "select object,cachedDate from \(config.tableName) where cachedDate > '\(flag!)' order by cachedDate asc limit \(config.length)"
        var values = [(Data, String)]()
        do {
            let rs = try database.executeQuery(sql, values: nil)
            var lastFlag = ""
            while rs.next() {
                if let d = rs.data(forColumnIndex: 0), let s = rs.string(forColumnIndex: 1) {
                    values.append((d, s))
                    lastFlag = s
                }
            }
            rs.close()
            callBack(true, "获取数据成功", values, lastFlag)
        } catch {
            callBack(false, "数据库查询操作失败", nil, nil)
            return
        }
    }
    
    func deleteTableWithConfig(_ database: FMDatabase,
                               config: CacheBusinessConfig,
                               callBack: IsCompleteCallBack?) {
        if !self.isTableExistWith(database: database, config: config) {
            debugPrint("该表不存在")
            return
        }
        let sql = "drop table \(config.tableName)"
        do {
            try database.executeUpdate(sql, values: nil)
            self.tables.remove(config.tableName)
            callBack?(true)
        } catch {
            debugPrint("删除数据库信息失败，\(#line)")
            callBack?(false)
        }
    }
    
    func deleteDataWithConfig(_ database: FMDatabase,
                              config: CacheBusinessConfig,
                              values:[String],
                              callBack:  IsCompleteCallBack?) {
        if !self.isTableExistWith(database: database, config: config) {
            return
        }
        
        guard database.beginTransaction() else {
            debugPrint("⚠️开启事务失败\(#line)")
            callBack?(false)
            return
        }
        
        for item in values {
            let sql = "delete from \(config.tableName) where objectID = '\(item)'"
            do {
                try database.executeUpdate(sql, values: nil)
            } catch {
                debugPrint("⚠️\(sql)执行错误，删除\(config.tableName)表数据失败!\(#line)")
                callBack?(false)
                return
            }
        }
        
        guard database.commit() else {
            debugPrint("⚠️提交事务失败\(#line)")
            callBack?(false)
            return
        }
        callBack?(true)
    }
    
    func isTableExistWith(database: FMDatabase, config: CacheBusinessConfig) -> Bool {
        self.setupTableList(database)
        if self.tables.contains(config.tableName) {
            return true
        }
        return false
    }
}
