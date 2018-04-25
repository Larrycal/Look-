////
////  BaseNavigationHeader.swift
////  Look!
////
////  Created by 柳钰柯 on 2018/3/26.
////  Copyright © 2018年 Larry. All rights reserved.
////
//
//import UIKit
//import RxSwift
//import RxCocoa
//import SnapKit
//import AudioToolbox
//
//// 导航状态枚举
//enum NavigationStatus:String {
//    case home = "home"
//    case discovery = "discovery"
//    case message = "message"
//    case me = "me"
//}
//
//class BaseNavigationHeader: UIView {
//
//    var bouncedUpHandler:((_ bouncedView:UIView)->Void)?
//
//    // MARK: - 公共属性
//    var navigationStatus:NavigationStatus = NavigationStatus.home {
//        didSet {
//            self.navigationStatusDidChangeHandler?(navigationStatus)
//        }
//    }
//    var navigationStatusDidChangeHandler:((_ status: NavigationStatus)->Void)?
//
//    // MARK: - 生命周期以及覆盖函数
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func layoutSubviews() {
//        let c = CGFloat(integerLiteral: self.buttons.count)
//        let space = (self.width-42*c) / (c+1)
//        var lastItem:UIButton?
//        for item in self.buttons {
//            if lastItem == nil {
//                item.snp.remakeConstraints { (make) in
//                    make.left.equalTo(space)
//                    make.centerY.equalToSuperview()
//                }
//            } else {
//                item.snp.remakeConstraints { (make) in
//                    make.left.equalTo(lastItem!.snp.right).offset(space)
//                    make.centerY.equalToSuperview()
//                }
//            }
//            lastItem = item
//        }
//    }
//
//    // MARK: - 私有方法
//    private func setNecessaryButtonSeleted(_ status:NavigationStatus){
//        for item in self.buttons {
//            item.isSelected = false
//        }
//        if let index = self.statuses.index(of: status) {
//            self.buttons[index].isSelected = true
//        }
//        self.navigationStatus = status
//        AudioServicesPlaySystemSound(1519)
//        self.showView(with: status)
//    }
//
//    private func showView(with status:NavigationStatus) {
//        if let index = self.statuses.index(of: status) {
//            for item in self.navigationSubviews {
//                item.isHidden = true
//            }
//            self.navigationSubviews[index].isHidden = false
//            self.animateShow(with: self.navigationSubviews[index])
//        }
//    }
//
//    private func animateShow(with view:UIView) {
//        // 向上推
//        self.bouncedUpHandler?(view)
//        view.y = baseBouncedTableViewMaxY
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 2, options: .curveEaseInOut, animations: {
//            view.y = baseBouncedTableViewMinY
//        }) { (finish) in
//        }
//    }
//
//    // MARK: - 公共方法
//    func addNavigationSubview(_ view:UIView, with status:NavigationStatus, with button:UIButton) {
//        self.addSubview(button)
//        self.navigationSubviews.append(view)
//        self.statuses.append(status)
//        self.buttons.append(button)
//
//        button.rx.tap.map {
//            return status
//            }.subscribe(onNext: { [weak self](status) in
//                guard let weakSelf = self else {return}
//                weakSelf.setNecessaryButtonSeleted(status)
//            })
//        .disposed(by: disposeBag)
//    }
//
//    private let disposeBag = DisposeBag()
//    private var navigationSubviews = [UIView]()
//    private var statuses = [NavigationStatus]()
//    private var buttons = [UIButton]()
//}
