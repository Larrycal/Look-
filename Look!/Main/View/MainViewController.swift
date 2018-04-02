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
        self.view.addSubview(self.messageTableView.view)
        self.view.addSubview(self.discoveryTableView.view)
        self.view.addSubview(self.meTableView.view)
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(44)
            make.height.equalTo(30)
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
        
//        self.homeTableView.view.snp.makeConstraints { (make) in
//            make.left.right.equalTo(0)
//            make.bottom.equalTo(10)
//        }
//
//        self.discoveryTableView.view.snp.makeConstraints { (make) in
//            make.top.equalTo(self.homeTableView.view)
//            make.left.right.equalTo(0)
//            make.bottom.equalTo(10)
//        }
//
//        self.messageTableView.view.snp.makeConstraints { (make) in
//            make.top.equalTo(self.homeTableView.view)
//            make.left.right.equalTo(0)
//            make.bottom.equalTo(10)
//        }
//
//        self.meTableView.view.snp.makeConstraints { (make) in
//            make.top.equalTo(self.homeTableView.view)
//            make.left.right.equalTo(0)
//            make.bottom.equalTo(10)
//        }
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
        
        temp.bouncedUpHandler = { [weak self]_ in
            guard let weakSelf = self else {return}
            weakSelf.titleArrow.transform = CGAffineTransform(rotationAngle: Constants.PI)
        }
        
        temp.addNavigationSubview(homeTableView.view, with: NavigationStatus.home, with: self.homeButton)
        temp.addNavigationSubview(discoveryTableView.view, with: NavigationStatus.discovery, with: self.discoveryButton)
        temp.addNavigationSubview(messageTableView.view, with: NavigationStatus.message, with: self.messageButton)
        temp.addNavigationSubview(meTableView.view, with: NavigationStatus.me, with: self.meButton)
        return temp
    }()
    
    private lazy var homeTableView:HomeTableViewController = {
        let temp = HomeTableViewController()
        temp.view.frame = CGRect(x: 0, y: baseBouncedTableViewMinY, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - baseBouncedTableViewMinY)
        temp.bouncedDownHandler = { [weak self]_ in
            guard let weakSelf = self else {return}
            weakSelf.titleArrow.transform = CGAffineTransform(rotationAngle: 0)
        }
        temp.bouncedUpHandler = { [weak self]_ in
            guard let weakSelf = self else {return}
            weakSelf.titleArrow.transform = CGAffineTransform(rotationAngle: Constants.PI)
        }
        return temp
    }()
    
    private lazy var meTableView:MeTableViewController = {
        let temp = MeTableViewController()
        temp.bouncedDownHandler = { [weak self]_ in
            guard let weakSelf = self else {return}
            weakSelf.titleArrow.transform = CGAffineTransform(rotationAngle: 0)
        }
        temp.bouncedUpHandler = { [weak self]_ in
            guard let weakSelf = self else {return}
            weakSelf.titleArrow.transform = CGAffineTransform(rotationAngle: Constants.PI)
        }
        temp.view.isHidden = true
        return temp
    }()
    
    private lazy var messageTableView:MessageTableViewController = {
        let temp = MessageTableViewController()
        temp.bouncedDownHandler = { [weak self]_ in
            guard let weakSelf = self else {return}
            weakSelf.titleArrow.transform = CGAffineTransform(rotationAngle: 0)
        }
        temp.bouncedUpHandler = { [weak self]_ in
            guard let weakSelf = self else {return}
            weakSelf.titleArrow.transform = CGAffineTransform(rotationAngle: Constants.PI)
        }
        temp.view.isHidden = true
        return temp
    }()
    
    private lazy var discoveryTableView:DiscoveryTableViewController = {
        let temp = DiscoveryTableViewController()
        temp.bouncedDownHandler = { [weak self]_ in
            guard let weakSelf = self else {return}
            weakSelf.titleArrow.transform = CGAffineTransform(rotationAngle: 0)
        }
        temp.bouncedUpHandler = { [weak self]_ in
            guard let weakSelf = self else {return}
            weakSelf.titleArrow.transform = CGAffineTransform(rotationAngle: Constants.PI)
        }
        temp.view.isHidden = true
        return temp
    }()
    
    private lazy var homeButton:UIButton = {
        let temp = UIButton(frame: CGRect(x: 0, y: 0, width: 42, height: 42))
        temp.isSelected = true
        temp.setBackgroundImage(UIImage(named: "home"), for: .normal)
        temp.setBackgroundImage(UIImage(named: "home_selected"), for: .selected)
        return temp
    }()
    
    private lazy var discoveryButton:UIButton = {
        let temp = UIButton(frame: CGRect(x: 0, y: 0, width: 42, height: 42))
        temp.setBackgroundImage(UIImage(named: "discovery"), for: .normal)
        temp.setBackgroundImage(UIImage(named: "discovery_selected"), for: .selected)
        return temp
    }()
    
    private lazy var messageButton:UIButton = {
        let temp = UIButton(frame: CGRect(x: 0, y: 0, width: 42, height: 42))
        temp.setBackgroundImage(UIImage(named: "message"), for: .normal)
        temp.setBackgroundImage(UIImage(named: "message_selected"), for: .selected)
        return temp
    }()
    
    private lazy var meButton:UIButton = {
        let temp = UIButton(frame: CGRect(x: 0, y: 0, width: 42, height: 42))
        temp.setBackgroundImage(UIImage(named: "me"), for: .normal)
        temp.setBackgroundImage(UIImage(named: "me_selected"), for: .selected)
        return temp
    }()
    
    private let disposeBag = DisposeBag()
}
