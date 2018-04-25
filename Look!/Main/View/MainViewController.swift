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

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    // MARK: - 私有方法
    private func setup() {
        self.view.backgroundColor = UIColor(hexValue: 0xe62565)
        self.view.frame = UIScreen.main.bounds

        self.addChildWithController(self.homeTableView, title: "首页", tabImage: "home")
        self.addChildWithController(self.discoveryTableView, title: "发现", tabImage: "discovery")
        self.addChildWithController(self.messageTableView, title: "消息", tabImage: "message")
        self.addChildWithController(self.meTableView, title: "个人", tabImage: "me")
    }

    private func addChildWithController(_ controller:UIViewController,title:String,tabImage:String) {
        controller.title = title
        controller.tabBarItem.image = UIImage(named: tabImage)?.withRenderingMode(.alwaysOriginal)
        controller.tabBarItem.selectedImage = UIImage(named: "\(tabImage)_selected")?.withRenderingMode(.alwaysOriginal)
        controller.tabBarItem.title = title
//        controller.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:Constants.color8,NSFontAttributeName:
//        UIFont(name: "PingFangSC-Light", size: 10)!], for: UIControlState())
        controller.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3 * 8)
        let navigationController = UINavigationController(rootViewController: controller)
        self.addChildViewController(navigationController)
    }

    // MARK: - 事件响应

    // MARK: - 私有属性
//    private lazy var titleLabel: UILabel = {
//        let temp = UILabel()
//        temp.text = "首页"
//        temp.textColor = UIColor.white
//        temp.font = UIFont.boldSystemFont(ofSize: 24.0)
//        return temp
//    }()

//    private lazy var titleArrow: UIImageView = {
//        let temp = UIImageView()
//        temp.image = UIImage(named: "title_arrow")
//        temp.transform = CGAffineTransform(rotationAngle: Constants.PI)
//        return temp
//    }()

//    private lazy var navigationHeader: BaseNavigationHeader = {
//        let temp = BaseNavigationHeader()
//
//        temp.backgroundColor = UIColor.white
//        temp.layer.cornerRadius = 20
//
//        temp.navigationStatusDidChangeHandler = { [weak self](status) in
//            guard let weakSelf = self else {
//                return
//            }
//            switch status {
//            case .home:
//                weakSelf.titleLabel.text = "首页"
//            case .discovery:
//                weakSelf.titleLabel.text = "发现"
//            case .message:
//                weakSelf.titleLabel.text = "消息"
//            case .me:
//                weakSelf.titleLabel.text = "个人"
//            }
//        }
//
//        temp.bouncedUpHandler = { [weak self]_ in
//            guard let weakSelf = self else {
//                return
//            }
//            weakSelf.titleArrow.transform = CGAffineTransform(rotationAngle: Constants.PI)
//        }
//
//        temp.addNavigationSubview(homeTableView.view, with: NavigationStatus.home, with: self.homeButton)
//        temp.addNavigationSubview(discoveryTableView.view, with: NavigationStatus.discovery, with: self.discoveryButton)
//        temp.addNavigationSubview(messageTableView.view, with: NavigationStatus.message, with: self.messageButton)
//        temp.addNavigationSubview(meTableView.view, with: NavigationStatus.me, with: self.meButton)
//        return temp
//    }()

    private lazy var homeTableView: HomeTableViewController = {
        let temp = HomeTableViewController(style: .grouped)
        return temp
    }()

    private lazy var meTableView: MeTableViewController = {
        let temp = MeTableViewController()
        return temp
    }()

    private lazy var messageTableView: MessageTableViewController = {
        let temp = MessageTableViewController()
        return temp
    }()

    private lazy var discoveryTableView: DiscoveryTableViewController = {
        let temp = DiscoveryTableViewController()
        return temp
    }()

//    private lazy var homeButton: UIButton = {
//        let temp = UIButton(frame: CGRect(x: 0, y: 0, width: 42, height: 42))
//        temp.isSelected = true
//        temp.setBackgroundImage(UIImage(named: "home"), for: .normal)
//        temp.setBackgroundImage(UIImage(named: "home_selected"), for: .selected)
//        return temp
//    }()
//
//    private lazy var discoveryButton: UIButton = {
//        let temp = UIButton(frame: CGRect(x: 0, y: 0, width: 42, height: 42))
//        temp.setBackgroundImage(UIImage(named: "discovery"), for: .normal)
//        temp.setBackgroundImage(UIImage(named: "discovery_selected"), for: .selected)
//        return temp
//    }()
//
//    private lazy var messageButton: UIButton = {
//        let temp = UIButton(frame: CGRect(x: 0, y: 0, width: 42, height: 42))
//        temp.setBackgroundImage(UIImage(named: "message"), for: .normal)
//        temp.setBackgroundImage(UIImage(named: "message_selected"), for: .selected)
//        return temp
//    }()
//
//    private lazy var meButton: UIButton = {
//        let temp = UIButton(frame: CGRect(x: 0, y: 0, width: 42, height: 42))
//        temp.setBackgroundImage(UIImage(named: "me"), for: .normal)
//        temp.setBackgroundImage(UIImage(named: "me_selected"), for: .selected)
//        return temp
//    }()

    private let disposeBag = DisposeBag()
}
