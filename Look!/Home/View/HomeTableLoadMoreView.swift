//
//  HomeTableLoadMoreView.swift
//  Look!
//
//  Created by 柳钰柯 on 2018/4/25.
//  Copyright © 2018年 Larry. All rights reserved.
//

import UIKit
import SnapKit

class HomeTableLoadMoreView: UIView {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimating() {
        self.activityView.isHidden = false
        self.activityView.startAnimating()
        self.titleLabel.isHidden = true
    }
    
    func isAnimating() -> Bool {
        return self.activityView.isAnimating
    }
    
    func stopAnimating() {
        self.activityView.isHidden = true
        self.activityView.stopAnimating()
        self.titleLabel.isHidden = true
    }
    
    func noMoreData() {
        self.titleLabel.isHidden = false
    }
    
    func reloadData() {
        self.titleLabel.isHidden = true
    }
    
    private func setup() {
        self.addSubview(self.activityView)
        self.addSubview(self.titleLabel)
        
        self.activityView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(40)
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.activityView.snp.bottom).offset(5)
            make.centerX.equalTo(self.activityView)
        }
    }
    
    lazy var activityView:UIActivityIndicatorView = {
        let temp = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        return temp
    }()
    
    lazy var titleLabel:UILabel = {
        let temp = UILabel()
        temp.text = "没有更多了"
        temp.font = UIFont.systemFont(ofSize: 14.0)
        temp.textColor = UIColor.gray
        temp.isHidden = true
        return temp
    }()
    
}
