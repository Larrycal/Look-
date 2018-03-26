//
// MainViewController.swift
// Look!
//
// Created by 柳钰柯 on 2018/3/16.
// Copyright (c) 2018 Larry. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import AudioToolbox

class MainViewController:UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    // MARK: - 私有方法
    private func setup(){
        self.view.backgroundColor = UIColor(hexValue:0xe62565)
        self.view.frame = UIScreen.main.bounds
        
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.titleArrow)
        self.view.addSubview(self.navigationHeader)
        self.view.addSubview(self.homeTableView.view)
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(44)
            make.centerX.equalToSuperview()
        }
        
        self.titleArrow.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(8)
            make.height.equalTo(11)
            make.width.equalTo(37)
            make.centerX.equalTo(self.titleLabel)
        }
        
        self.navigationHeader.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleArrow.snp.bottom).offset(8)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(80)
        }
        
        self.homeTableView.view.snp.makeConstraints { (make) in
            homeTableViewTopConstraint = make.top.equalTo(self.titleArrow.snp.bottom).offset(8).constraint
            make.left.right.bottom.equalTo(0)
        }

    }
    // MARK: - 事件响应
    
    // MARK: - 私有属性
    private lazy var titleLabel:UILabel = {
        let temp = UILabel()
        temp.text = "首页"
        temp.textColor = UIColor.white
        temp.font = UIFont.boldSystemFont(ofSize: 24.0)
        return temp
    }()
    
    private lazy var titleArrow:UIImageView = {
        let temp = UIImageView()
        temp.image = UIImage(named: "title_arrow")
        temp.transform = CGAffineTransform(rotationAngle: Constants.PI)
        return temp
    }()
    
    private lazy var navigationHeader:BaseNavigationHeader = {
        let temp = BaseNavigationHeader()
        
        temp.backgroundColor = UIColor.white
        temp.layer.cornerRadius = 20
        
        temp.navigationStatusDidChangeHandler = {[weak self](status) in
            guard let weakSelf = self else {return}
            switch status {
            case .home:
                weakSelf.titleLabel.text = "首页"
            case .discovery:
                weakSelf.titleLabel.text = "发现"
            case .message:
                weakSelf.titleLabel.text = "消息"
            case .me:
                weakSelf.titleLabel.text = "个人"
            }
        }
        
        return temp
    }()
    
    private lazy var homeTableView:HomeTableViewController = {
        let temp = HomeTableViewController()
        temp.bouncedDownHandler = { [weak self]_,_ in
            guard let weakSelf = self else {return}
            weakSelf.titleArrow.transform = CGAffineTransform(rotationAngle: 0)
        }
        temp.bouncedUpHandler = { [weak self]_,_ in
            guard let weakSelf = self else {return}
            weakSelf.titleArrow.transform = CGAffineTransform(rotationAngle: Constants.PI)
        }
        return temp
    }()
    
    private let disposeBag = DisposeBag()
    private var homeTableViewTopConstraint:SnapKit.Constraint!
}
