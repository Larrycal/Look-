//
// FeedService.swift
// CacheCore
//
// Created by 柳钰柯 on 2018/4/22.
// Copyright (c) 2018 Larry. All rights reserved.
//

import Foundation
import Moya

enum FeedService {
    case photos(page:Int)
}

extension FeedService: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.unsplash.com")!
    }
    var path: String {
        switch self {
            case .photos:
                return "/photos"
        }
    }
    var method: Moya.Method {
        switch self {
            case .photos:
                return .get
        }
    }
    var sampleData: Data {
        switch self {
            case .photos:
                return "No sampleData".utf8Encoded
        }
    }
    var task: Task {
        switch self {
        case let .photos(page):
            return .requestParameters(parameters: ["order_by": "popular","page":page], encoding: URLEncoding.queryString)
        }
    }
    var headers: [String: String]? {
        return ["Accept-Version": "v1", "Authorization": "Client-ID fdfb2e5c7b4754b38a2357f6aa803d3098054cfd46907fed9c13b5fba030392d"]
    }
}

// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}

