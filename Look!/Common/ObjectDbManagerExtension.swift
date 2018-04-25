//
//  ObjectDbManagerExtension.swift
//  Tuchong
//
//  Created by 柳钰柯 on 2017/9/24.
//  Copyright © 2017年 Bytedance. All rights reserved.
//

import Foundation

extension ObjectDbManager {
    
    func createCachedTableWithName(_ database:FMDatabase,tableName:String) -> Bool {
        let sql = "CREATE TABLE IF NOT EXISTS \"\(tableName)\" (\"object\" blob, \"objectid\" text NOT NULL PRIMARY KEY,\"date\" text,\"cachedTimestmp\" text DEFAULT (strftime('%s','now','localtime')));"
        let result = database.executeUpdate(sql)
        if !result {
            print("创建表\"\(tableName)\"失败!")
        }
        return result
    }
    
    func insertCachedDataWithTableName(_ database:FMDatabase,tableName:String,conditions:[(id:String,value:Data,date:String)]) -> Bool {
        let args = NSMutableArray()
        guard database.beginTransaction() else {print("⚠️开启事务失败");return false}
        for item in conditions {
            args.removeAllObjects()
            args.add(item.value)
            args.add(item.id)
            args.add(item.date)
            let sql = "replace into \"\(tableName)\" ( \"object\", \"objectid\", \"date\") values ( ?,?,?);"
            if !database.executeUpdate(sql, withArgumentsIn: args as [AnyObject]) {
                print("⚠️\(sql)执行错误，插入数据到表\"\(tableName)\"中失败!")
                return false
            }
        }
        guard database.commit() else {print("⚠️提交事务失败");return false}
        return true
    }
    
    func datasWithTableName(_ database:FMDatabase,tableName:String,length:Int, lastIndex:Int,timestmp:Int) -> Array<(id:String,cacheDta:Data,cachedTimestmp:Int)>? {
        let sql = lastIndex == 0 ? "select objectid,object,cachedTimestmp from \"\(tableName)\" order by date desc limit \(length)" : "select objectid,object,cachedTimestmp from \"\(tableName)\" where date <= (select date from \"\(tableName)\" where objectid = \(lastIndex)) and objectid != \(lastIndex)  order by date desc limit \(length)"
        var datas:Array<(String,Data,Int)>? = nil
        let rs = database.executeQuery(sql, withArgumentsIn: nil)
        if rs == nil {
            return datas
        }
        while (rs?.next())! {
            if datas == nil {
                datas = Array<(String,Data,Int)>()
            }
            datas?.append(((rs?.string(forColumnIndex: 0))!,(rs?.data(forColumnIndex: 1))!,Int((rs?.int(forColumnIndex: 2))!)))
        }
        rs?.close()
        return datas
    }
    
    func deleteDataWithTableName(_ database:FMDatabase,tableName:String,conditions:[(key:String,value:String)])->Bool{
        var isFirst = true
        var result = false
        var sql = conditions.count > 0 ? "delete from \"\(tableName)\" where" : "delete from \"\(tableName)\""
        for condition in conditions {
            if isFirst {
                isFirst = false
                sql += " \(condition.key)=\"\(condition.value)\""
            } else {
                sql += " and \(condition.key)=\"\(condition.value)\""
            }
        }
        if database.executeUpdate(sql) {
            result = true
        } else {
            result = false
            print("删除表\"\(tableName)\"数据失败!")
        }
        return result
    }
}
