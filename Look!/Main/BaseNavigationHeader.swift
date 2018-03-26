//
//  BaseNavigationHeader.swift
//  Look!
//
//  Created by 柳钰柯 on 2018/3/26.
//  Copyright © 2018年 Larry. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import AudioToolbox

enum NavigationStatus:String {
    case home = "home"
    case discovery = "discovery"
    case message = "message"
    case me = "me"
}

class BaseNavigationHeader: UIView {
    
    // MARK: - 公共属性
    var navigationStatus:NavigationStatus = NavigationStatus.home {
        didSet {
            self.navigationStatusDidChangeHandler?(navigationStatus)
        }
    }
    var navigationStatusDidChangeHandler:((_ status: NavigationStatus)->Void)?
    
    // MARK: - 生命周期以及覆盖函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let space = (self.width-42*4) / 5
        
        self.homeButton.snp.remakeConstraints { (make) in
            make.left.equalTo(space)
            make.centerY.equalToSuperview()
        }
        
        self.discoveryButton.snp.remakeConstraints { (make) in
            make.left.equalTo(self.homeButton.snp.right).offset(space)
            make.centerY.equalToSuperview()
        }
        
        self.messageButton.snp.remakeConstraints { (make) in
            make.left.equalTo(self.discoveryButton.snp.right).offset(space)
            make.centerY.equalToSuperview()
        }
        
        self.meButton.snp.remakeConstraints { (make) in
            make.left.equalTo(self.messageButton.snp.right).offset(space)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - 私有方法
    private func setup() {
        self.addSubview(self.homeButton)
        self.addSubview(self.discoveryButton)
        self.addSubview(self.messageButton)
        self.addSubview(self.meButton)
    }
    
    private func setNecessaryButtonSeleted(_ button:UIButton){
        self.discoveryButton.isSelected = false
        self.messageButton.isSelected = false
        self.homeButton.isSelected = false
        self.meButton.isSelected = false
        
        button.isSelected = true
        
        switch button.tag {
            case 0:
                self.navigationStatus = .home
            case 1:
                self.navigationStatus = .discovery
            case 2:
                self.navigationStatus = .message
            case 3:
                self.navigationStatus = .me
            default:
                self.navigationStatus = .home
        }
        
        AudioServicesPlaySystemSound(1519)
    }
    
    // MARK: - 事件响应
    func homeButtonSelected(_ sender:UIButton) {
        self.setNecessaryButtonSeleted(sender)
    }
    
    func discoveryButtonSelected(_ sender:UIButton) {
        self.setNecessaryButtonSeleted(sender)
    }
    
    func messageButtonSelected(_ sender:UIButton) {
        self.setNecessaryButtonSeleted(sender)
    }
    
    func meButtonSelected(_ sender:UIButton) {
        self.setNecessaryButtonSeleted(sender)
    }
    
    
    // MARK: - 私有属性
    private lazy var homeButton:UIButton = {
        let temp = UIButton(frame: CGRect(x: 0, y: 0, width: 42, height: 42))
        temp.tag = 0
        temp.isSelected = true
        temp.setBackgroundImage(UIImage(named: "home"), for: .normal)
        temp.setBackgroundImage(UIImage(named: "home_selected"), for: .selected)
        temp.rx.tap.subscribe(onNext: { [weak self] in
            guard let weakSelf = self else {return}
            weakSelf.homeButtonSelected(temp)
        }).disposed(by: disposeBag)
        return temp
    }()
    
    private lazy var discoveryButton:UIButton = {
        let temp = UIButton(frame: CGRect(x: 0, y: 0, width: 42, height: 42))
        temp.tag = 1
        temp.setBackgroundImage(UIImage(named: "discovery"), for: .normal)
        temp.setBackgroundImage(UIImage(named: "discovery_selected"), for: .selected)
        temp.rx.tap.subscribe(onNext: { [weak self] in
            guard let weakSelf = self else {return}
            weakSelf.discoveryButtonSelected(temp)
        }).disposed(by: disposeBag)
        return temp
    }()
    
    private lazy var messageButton:UIButton = {
        let temp = UIButton(frame: CGRect(x: 0, y: 0, width: 42, height: 42))
        temp.tag = 2
        temp.setBackgroundImage(UIImage(named: "message"), for: .normal)
        temp.setBackgroundImage(UIImage(named: "message_selected"), for: .selected)
        temp.rx.tap.subscribe(onNext: { [weak self] in
            guard let weakSelf = self else {return}
            weakSelf.messageButtonSelected(temp)
        }).disposed(by: disposeBag)
        return temp
    }()
    
    private lazy var meButton:UIButton = {
        let temp = UIButton(frame: CGRect(x: 0, y: 0, width: 42, height: 42))
        temp.tag = 3
        temp.setBackgroundImage(UIImage(named: "me"), for: .normal)
        temp.setBackgroundImage(UIImage(named: "me_selected"), for: .selected)
        temp.rx.tap.subscribe(onNext: { [weak self] in
            guard let weakSelf = self else {return}
            weakSelf.meButtonSelected(temp)
        }).disposed(by: disposeBag)
        return temp
    }()
    
    private let disposeBag = DisposeBag()
}
