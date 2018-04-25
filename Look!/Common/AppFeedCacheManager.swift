//
//  AppFeedCacheManager.swift
//  Tuchong
//
//  Created by 柳钰柯 on 2017/9/25.
//  Copyright © 2017年 Bytedance. All rights reserved.
//

import Foundation
import ObjectMapper
import TuchongKit

class AppFeedCacheManager {
    
    /// 获取单个数据
    ///
    /// - Parameters:
    ///   - tableName: 表名
    ///   - conditions: 过滤条件 key:键名 value:键值。例如：需要筛选表中id=100的元素，key:id,value:100
    ///   - success: 成功闭包回调
    ///   - faliure: 失败闭包回调
//    class func fetchCachedData<T:Mappable>(tableName:String,conditions:[(key:String,value:String)], success:((_ result:T,_ timestmp:Int) -> Void)?, faliure:((_ code:Int?, _ message:String) -> Void)?) {
//        AppDbManager.sharedCacheManager.executeInDataBase { (db) in
//            let (data,timestmp) = AppDbManager.sharedCacheManager.dataWithTableName(db, tableName: tableName, conditions: conditions)
//            if let dic =  data?.toDictionary() {
//                guard let confirmDic = dic as? [String:Any] else {faliure?(nil,"\(dic)字典转换失败");return}
//                if let model = Mapper<T>().map(JSON: confirmDic) {
//                    success?((model,timestmp!))
//                } else {
//                    faliure?(nil,"\(dic)字典转模型失败")
//                }
//            } else {
//                faliure?(nil,"\(data?.debugDescription ?? "数据为空,")转换字典失败")
//            }
//        }
//    }
    
    /// 获取一组数据
    ///
    /// - Parameters:
    ///   - tableName: 表名
    ///   - start: 从第几个数据开始
    ///   - length: 获取的数据长度
    ///   - success: 成功闭包回调
    ///   - faliure: 失败闭包回调
    class func fetchCachedDatas<T:Mappable>(tableName:String,config:AppFeedCachedConfig,length:Int, lastIndex:Int,timestmp:Int, success:(([T]) -> Void)?, faliure:((_ code:Int?, _ message:String) -> Void)?) {
        AppDbManager.sharedCacheManager.executeInDataBaseWithTempQueue { (db) in
            guard let datas = AppDbManager.sharedCacheManager.datasWithTableName(db, tableName: tableName, length: length,lastIndex:lastIndex, timestmp: timestmp) else {faliure?(nil,"从\(tableName)中获取数据失败");return}
            var dicResult = [T]()
            for item in datas {
                if let rs = item.cacheDta.toDictionary() as? [String:Any], let mapRs = Mapper<T>().map(JSON: rs) {
                    if Date().addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT(for: Date()))).timeIntervalSince1970 - Double(item.cachedTimestmp) <= config.validTime {
                        dicResult.append(mapRs)
                    } else {
                        print("\(item.id)缓存失效")
                        break
                    }
                } else {
                    print("\(item)转换为字典模型失败")
                }
            }
            if dicResult.count > 0 {
                success?(dicResult)
            } else {
                faliure?(nil,"data转换为模型全部失败，请检查程序逻辑")
            }
        }
    }
    
    /// 删除表数据
    ///
    /// - Parameters:
    ///   - tableName: 表名
    ///   - conditions: 过滤条件,若过滤条件元组为空白，则默认删除全表数据。key:键名 value:键值。例如：需要筛选表中id=100的元素，key:id,value:100
    ///   - callback: 删除完成的回调
    class func deleteCachedData(tableName:String,conditions:[(key:String,value:String)],callback:((_ result:Bool)->Void)?) {
        AppDbManager.sharedCacheManager.executeInDataBaseWithTempQueue { (db) in
            callback?(AppDbManager.sharedCacheManager.deleteDataWithTableName(db, tableName: tableName, conditions: conditions))
        }
    }
    
    /// 批量或单个插入数据
    ///
    /// - Parameters:
    ///   - tableName: 表名
    ///   - conditions: 需要插入数据库的值
    ///   - callback: 回调
    class func insertCachedDatas(tableName:String,conditions:[(id:String,value:Data,date:String)],callback:((_ result:Bool)->Void)?) {
        AppDbManager.sharedCacheManager.executeInDataBaseWithTempQueue { (db) in
            if db.tableExists(tableName) {
                callback?(AppDbManager.sharedCacheManager.insertCachedDataWithTableName(db, tableName: tableName, conditions: conditions))
            } else {
                if AppDbManager.sharedCacheManager.createCachedTableWithName(db, tableName: tableName) {
                    callback?(AppDbManager.sharedCacheManager.insertCachedDataWithTableName(db, tableName: tableName, conditions: conditions))
                } else {
                    callback?(false)
                }
            }
        }
    }
}
