//
// CacheHelper.swift
// CacheCore
//
// Created by 柳钰柯 on 2018/4/17.
// Copyright (c) 2018 Larry. All rights reserved.
//

import Foundation
import ObjectMapper
import FMDB
import Moya

public typealias FetchCachedObjectCallBack<CacheMappable> = (_ isSuccess: Bool, _ message: String?, _ data: [CacheMappable]?, _ lastFlag:
    String?) -> Void
public typealias IsCompleteCallBack = (_ isSuccess: Bool) -> Void

public class CacheHelper<T:TargetType> {
    var provider:MoyaProvider<T>
    var config:CacheBusinessConfig
    public var target:T
    
    public init(provider: MoyaProvider<T>,config:CacheBusinessConfig,target: T){
        self.provider = provider
        self.config = config
        self.target = target
    }
    
    /// fetch Data
    public func fetchCachedData<M: CacheMappable>(config: CacheBusinessConfig,
                                                  flag: String?,
                                                  callBack: @escaping FetchCachedObjectCallBack<M>) {
        func fetchDataByNetwork() {
            self.provider.request(self.target) { result in
                switch result {
                case .success(let res):
                    do {
                        var rsJson: String
                        if config.keyPath == nil {
                            rsJson = try res.mapString()
                        } else {
                            rsJson = try res.mapString(atKeyPath: "\(config.keyPath!)")
                        }
                        guard let mapRs = Mapper<M>().mapArray(JSONString: rsJson) else {return}
                        let dataArray = mapRs.filter{ $0.toJSONString()?.data(using: String.Encoding.utf8) != nil}.map{ ($0.toJSONString()!.data(using: String.Encoding.utf8)!,$0.cachePrimaryKey)}
                        // Save cache to Database
                        DataBaseManager.shared.insertDataWithConfig(config, values: dataArray) { isSuccess,flag in
                            if isSuccess {
                                callBack(true, "从网络获取数据", mapRs, flag)
                            }
                        }
                    } catch {
                        debugPrint("data转换为String 失败")
                    }
                case .failure(let res):
                    callBack(false, "无缓存并且网络请求失败\(#line)", nil, nil)
                    debugPrint(res.errorDescription!)
                }
            }
        }
        
        DataBaseManager.shared.fetchDataWithConfig(config, flag: flag) { (isSuccess: Bool, msg: String?, d: [(Data, String)]?, f: String?) in
            if !isSuccess {
                fetchDataByNetwork()
            } else {
                if let data = d {
                    var dicResult = [M]()
                    for item in data {
                        guard let cachedDate = item.1.stringToDateByMillisecond() else {
                            fatalError("string 转 Date 失败")
                            continue
                        }
                        // 缓存有效性检测
                        if (Date().timeIntervalSince1970 - cachedDate.timeIntervalSince1970) <= config.validTime {
                            if let rs = String(data: item.0, encoding: String.Encoding.utf8),
                                let mapRs = Mapper<M>().map(JSONString: rs) {
                                dicResult.append(mapRs)
                            } else {
                                print("\(item.0)转换为字典模型失败")
                            }
                        }
                    }
                    if dicResult.count > 0 {
                        callBack(true, "获取缓存成功", dicResult, f)
                    } else {
                        debugPrint("缓存失效,重新从网络中获取")
                        fetchDataByNetwork()
                    }
                } else {
                    fetchDataByNetwork()
                }
            }
        }
    }
    
    /// 删除表
    public func deleteTableWith(config: CacheBusinessConfig,
                                callBack: IsCompleteCallBack?) {
        DataBaseManager.shared.deleteTableWith(config: config, callBack: callBack)
    }
    
    
    /// 删除表数据
    ///
    /// - Parameters:
    ///   - config: 缓存配置
    ///   - values: 需要删除的主键值，一般为CacheModel中的id
    ///   - callBack: 执行回调
    public func deleteDataWith(config: CacheBusinessConfig,
                               values: [String],
                               callBack: IsCompleteCallBack?) {
        DataBaseManager.shared.deleteDataWith(config: config, values: values, callBack: callBack)
    }
    
    /// 批量或单个插入数据
    public func insertCachedData<M: CacheMappable>(config: CacheBusinessConfig,
                                                   values: [M],
                                                   callBack: ((_ isSuccess:Bool, _ flag:String?)->Void)?) {
        var dataValues = [(Data,String)]()
        for item in values {
            guard let json = item.toJSONString() else {
                print("item to json 失败")
                return
            }
            guard let jsonData = json.data(using: .utf8) else { continue }
            dataValues.append((jsonData,item.cachePrimaryKey))
        }
        if dataValues.count > 0 {
            DataBaseManager.shared.insertDataWithConfig(config, values: dataValues, callBack: callBack)
        } else {
            debugPrint("插入数据库中数据为空，请检查数据！\(#function)")
            callBack?(false,nil)
        }
    }
}

// MARK: string to data
extension String {
    public func stringToDateByMillisecond() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter.date(from: self)
    }
}
