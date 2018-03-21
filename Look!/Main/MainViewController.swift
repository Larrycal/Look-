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

enum Result {
    case ok(message: String)
    case empty
    case failed(message: String)
}

class MainViewController:BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    private func setup(){
        self.view.backgroundColor = UIColor(hexValue:0xe62565)
        self.view.frame = UIScreen.main.bounds
        
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.titleArrow)
        self.view.addSubview(self.navigationHeader)
        
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
    }
    
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
        return temp
    }()
    
    private lazy var navigationHeader:UIView = {
        let temp = UIView()
        temp.backgroundColor = UIColor.white
        temp.layer.cornerRadius = 20
        return temp
    }()
    
}
