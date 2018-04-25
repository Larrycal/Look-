//
//  AppFeedCachedConfig.swift
//  Tuchong
//
//  Created by 柳钰柯 on 2017/10/15.
//  Copyright © 2017年 Bytedance. All rights reserved.
//

import Foundation
class AppFeedCachedConfig {
    var validTime:TimeInterval = 24*60*60
    
    init() {
    }
    
    convenience init(validTime:TimeInterval) {
        self.init()
        self.validTime = validTime
    }
    
}
