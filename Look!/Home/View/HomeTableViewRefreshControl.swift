//
//  HomeTableViewRefreshControl.swift
//  Look!
//
//  Created by 柳钰柯 on 2018/4/25.
//  Copyright © 2018年 Larry. All rights reserved.
//

import UIKit

class HomeTableViewRefreshControl: UIRefreshControl {

    override func beginRefreshing() {
        super.beginRefreshing()
        self.sendActions(for: .valueChanged)
    }

    override func endRefreshing() {
        super.endRefreshing()
//        self.sendActions(for: .valueChanged)
    }
}
