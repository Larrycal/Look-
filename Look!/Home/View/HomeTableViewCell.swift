//
//  HomeTableViewCell.swift
//  Look!
//
//  Created by 柳钰柯 on 2018/4/2.
//  Copyright © 2018年 Larry. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class HomeTableViewCell: UITableViewCell {

    var feedItem: FeedModel? {
        didSet {
            guard let item = feedItem else {
                print("feedmodel 模型数据出错")
                return
            }
            guard let url = URL(string: item.urls.thumb) else {
                print("图片URL出错")
                return
            }
            self.imageCover.kf.setImage(with: url)
            self.describeLabel.text = item.description
            self.titleLabel.text = item.id
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - 私有方法
    private func setup() {
        self.contentView.addSubview(self.shadowView)
        self.shadowView.addSubview(self.containerView)
        
        self.shadowView.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.bottom.equalTo(8)
        }
        
        self.containerView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }

        self.containerView.addSubview(self.imageCover)
        self.containerView.addSubview(self.titleLabel)
        self.containerView.addSubview(self.describeLabel)

        self.imageCover.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(280)
        }

        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.imageCover.snp.bottom).offset(8)
            make.left.equalTo(8)
            make.right.equalTo(-8)
        }

        self.describeLabel.snp.makeConstraints { make in
            make.left.equalTo(self.titleLabel)
            make.right.equalTo(-8)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(5)
            make.bottom.equalTo(-10)
        }
    }

    // MARK: - 私有属性
    private lazy var containerView: UIView = {
        let temp = UIView(frame: CGRect.zero)
        temp.backgroundColor = UIColor.white
        temp.layer.cornerRadius = 20
        temp.layer.masksToBounds = true
        return temp
    }()
    
    private lazy var shadowView: UIView = {
        let temp = UIView()
        temp.layer.shadowOffset = CGSize(width: 0, height: 10)
        temp.layer.shadowRadius = 20
        temp.layer.shadowOpacity = 0.8
        temp.layer.shadowColor = UIColor.lightGray.cgColor
        return temp
    }()

    private lazy var imageCover: UIImageView = {
        let temp = UIImageView()
        temp.image = UIImage(named: "IMG_5917")
        return temp
    }()

    private lazy var titleLabel: UILabel = {
        let temp = UILabel()
        temp.font = UIFont.boldSystemFont(ofSize: 14.0)
        return temp
    }()

    private lazy var describeLabel: UILabel = {
        let temp = UILabel()
        temp.numberOfLines = 0
        temp.font = UIFont.systemFont(ofSize: 12.0)
        return temp
    }()
}
