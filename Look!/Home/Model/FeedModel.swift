//
// FeedModel.swift
// CacheCore
//
// Created by 柳钰柯 on 2018/4/21.
// Copyright (c) 2018 Larry. All rights reserved.
//

import Foundation
import CacheCore
import ObjectMapper

class FeedModel: CacheMappable {
    var cachePrimaryKey: String = ""
    var id: String = ""
    var created_at: String = ""
    var updated_at: String = ""
    var width: Int = 0
    var height: Int = 0
    var color: Int = 0
    var description: String = ""
    var urls: ImageURLs!
    var likes: Int = 0

    required init?(map: Map) {}

    func mapping(map: Map) {
        self.cachePrimaryKey <- map["id"]
        self.id <- map["id"]
        self.created_at <- map["created_at"]
        self.updated_at <- map["updated_at"]
        self.width <- map["width"]
        self.height <- map["height"]
        self.color <- map["color"]
        self.description <- map["description"]
        self.likes <- map["likes"]
        self.urls <- map["urls"]
    }
}

class ImageURLs: Mappable {
    var raw: String = ""
    var full: String = ""
    var regular: String = ""
    var small: String = ""
    var thumb: String = ""

    required init?(map: Map) {}

    func mapping(map: Map) {
        self.raw <- map["raw"]
        self.full <- map["full"]
        self.regular <- map["regular"]
        self.small <- map["small"]
        self.thumb <- map["thumb"]
    }
}
