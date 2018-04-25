//
// HomeTableViewController.swift
// Look!
//
// Created by 柳钰柯 on 2018/3/16.
// Copyright (c) 2018 Larry. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class HomeTableViewController: UITableViewController {
    var feedViewModel = FeedViewModel()
    
    override func viewDidLoad() {
        self.setup()
    }
    
    private func setup() {
        self.tableView.backgroundColor = UIColor.white
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 80
        
        self.tableView.tableFooterView = self.loadMoreView
        
        // 刷新控件
        self.tableView.refreshControl = self.headerRefresh
        // 开始刷新
        self.refreshControl?.beginRefreshing()
        // 开启socket监听
//        self.feedViewModel.setupSocket()
        
    }
    
    func loadMore() {
        self.loadMoreView.startAnimating()
        self.feedViewModel.fetchFeedsModel(by: page) { [unowned self]isSuccess in
            if isSuccess {
                self.page += 1
                self.tableView.reloadData()
            }
            self.loadMoreView.stopAnimating()
        }
    }
    
    // MARK: - 事件响应
    @objc func footerRefresh(_ sender:UIRefreshControl) {
        self.feedViewModel.fetchFeedsModel(by: page) { [unowned self]isSuccess in
            if isSuccess {
                self.page += 1
                self.tableView.reloadData()
            }
            self.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.feedViewModel.feeds.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HomeTableViewCell(style: .default, reuseIdentifier: "cell")
        cell.feedItem = self.feedViewModel.getItemAt(index: indexPath.section)
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y;
        /*self.refreshControl.isRefreshing == NO加这个条件是为了防止下面的情况发生：
         每次进入UITableView，表格都会沉降一段距离，这个时候就会导致currentOffsetY + scrollView.frame.size.height   > scrollView.contentSize.height 被触发，从而触发loadMore方法，而不会触发refresh方法。
         */
        if currentOffsetY + scrollView.frame.size.height > scrollView.contentSize.height && !self.refreshControl!.isRefreshing && !self.loadMoreView.isAnimating() && self.loadMoreView.titleLabel.isHidden {
            self.loadMore()
        }
    }
    
    // MARK: - 私有属性
    private lazy var headerRefresh:HomeTableViewRefreshControl = {
        let temp = HomeTableViewRefreshControl()
        temp.tintColor = UIColor.gray
        temp.attributedTitle = NSAttributedString(string: "上拉刷新")
        temp.addTarget(self, action: #selector(footerRefresh(_:)), for: UIControlEvents.valueChanged)
        return temp
    }()
    
    private lazy var loadMoreView:HomeTableLoadMoreView = {
        let temp = HomeTableLoadMoreView(frame: CGRect(x: 0, y: 0, width: self.tableView.width, height: 60))
        return temp
    }()
    
    private var page: Int = 1
}
