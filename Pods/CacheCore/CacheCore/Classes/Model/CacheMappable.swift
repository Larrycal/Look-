//
//  CacheMappable.swift
//  CacheCore
//
//  Created by 柳钰柯 on 2018/4/23.
//  Copyright © 2018年 Larry. All rights reserved.
//

import Foundation
import ObjectMapper

public protocol CacheMappable: Mappable {
    // use this property to find object in database
    var cachePrimaryKey:String{get set}
}
