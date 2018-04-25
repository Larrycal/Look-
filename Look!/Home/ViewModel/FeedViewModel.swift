//
//  FeedViewModel.swift
//  Look!
//
//  Created by 柳钰柯 on 2018/4/25.
//  Copyright © 2018年 Larry. All rights reserved.
//

import Foundation
import CacheCore
import Moya

class FeedViewModel {
    var feeds = [FeedModel]()
    let config = CacheBusinessConfig(tableName: "Feed")
    var socketMg:NetWorkSocketManager?
    
    func setupSocket() {
        self.socketMg = NetWorkSocketManager(host: "127.0.0.1",port: 12345,config: self.config)
        self.socketMg?.start()
    }
    
    func fetchFeedsModel(by page:Int, callBack:@escaping ((_ isSuccess:Bool)->Void)) {
        let helper = CacheHelper(provider: provider, config: config, target: .photos(page: page))
        helper.fetchCachedData(config: config, flag: self.cacheFlag) { (isSuccess:Bool, msg:String?, data:[FeedModel]?, flag:String?) in
            if isSuccess {
                guard let d = data else {
                    callBack(false)
                    print(msg!)
                    return
                }
                for item in d {
                    print(item.id)
                }
                self.feeds.append(contentsOf: d)
                self.cacheFlag = flag
            }
            callBack(isSuccess)
        }
    }
    
    func getItemAt(index: Int) -> FeedModel? {
        if index >= self.feeds.count {
            return nil
        } else {
            return feeds[index]
        }
    }
    
    // MARK: - 私有属性
    private var cacheFlag: String?
    private var provider = MoyaProvider<FeedService>()
}
