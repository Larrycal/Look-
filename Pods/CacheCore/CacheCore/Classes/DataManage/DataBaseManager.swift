//
// DataBaseManager.swift
// CacheCore
//
// Created by 柳钰柯 on 2018/4/17.
// Copyright (c) 2018 Larry. All rights reserved.
//

import Foundation
import FMDB

typealias FetchCachedDataCallBack = (_ isSuccess: Bool, _ message: String?, _ data: [(Data, String)]?, _ lastFlag: String?) -> Void

public class DataBaseManager {
    
    // 单例
    static let shared: DataBaseManager = DataBaseManager()
    
    // MARK: - 私有属性
    private let appDbName = "CacheCore.sqlite"
    private var databaseQueue: FMDatabaseQueue!
    private let dbUtil = DataBaseSQLUtil()
    
    // MARK: - 私有方法
    private init() {
        var dbPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                         FileManager.SearchPathDomainMask.userDomainMask,
                                                         true).first!
        dbPath.append(self.appDbName)
        debugPrint(dbPath)
        self.databaseQueue = FMDatabaseQueue(path: dbPath)
    }
    
    // MARK: - 公共方法
    func executeInDataBase(_ operate: @escaping ((_ db: FMDatabase) -> Void)) {
        self.databaseQueue.inDatabase { (db) -> Void in
            operate(db)
        }
    }
    
    func executeInDataBaseWithTempQueue(_ operate: @escaping ((_ db: FMDatabase) -> Void)) {
        var dbPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                         FileManager.SearchPathDomainMask.userDomainMask,
                                                         true).first!
        dbPath.append(self.appDbName)
        let dbQueue = FMDatabaseQueue(path: dbPath)
        dbQueue.inDatabase({ (db) in
            operate(db)
        })
    }
    
    func deleteTableWith(config: CacheBusinessConfig,
                         callBack: IsCompleteCallBack?) {
        self.executeInDataBase { [unowned self] db in
            self.dbUtil.deleteTableWithConfig(db, config: config, callBack: callBack)
        }
    }
    
    func deleteDataWith(config: CacheBusinessConfig,
                        values: [String],
                        callBack: IsCompleteCallBack?) {
        self.executeInDataBase { [unowned self] db in
            self.dbUtil.deleteDataWithConfig(db, config: config, values: values, callBack: callBack)
        }
    }
    
    func insertDataWithConfig(_ config: CacheBusinessConfig, values: [(Data,String)], callBack: ((_ isSuccess:Bool,_ flag:String?)->Void)?) {
        self.executeInDataBase { [unowned self] db in
            self.dbUtil.insertCachedDataWithConfig(db, config: config, values: values, callBack: callBack)
        }
    }
    
    func fetchDataWithConfig(_ config: CacheBusinessConfig, flag: String?, callBack: @escaping FetchCachedDataCallBack) {
        self.executeInDataBase { [unowned self] db in
            self.dbUtil.dataWithConfig(db, config: config, flag: flag, callBack: callBack)
        }
    }
}
