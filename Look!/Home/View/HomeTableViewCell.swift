//
//  HomeTableViewCell.swift
//  Look!
//
//  Created by 柳钰柯 on 2018/4/2.
//  Copyright © 2018年 Larry. All rights reserved.
//

import UIKit
import SnapKit

class HomeTableViewCell: UITableViewCell {

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
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.imageScrollView)
        self.contentView.addSubview(self.pageControl)
        self.contentView.addSubview(self.likeButton)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.dotLabel)
        self.contentView.addSubview(self.describeLabel)
        self.nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(8)
        }
        self.imageScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(5)
            make.left.right.equalTo(0)
            make.height.equalTo(280)
        }
        self.pageControl.snp.makeConstraints { (make) in
            make.top.equalTo(self.imageScrollView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        self.likeButton.snp.makeConstraints { make in
            make.left.equalTo(self.nameLabel)
            make.width.height.equalTo(20)
            make.top.equalTo(self.imageScrollView.snp.bottom).offset(8)
        }
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.likeButton.snp.bottom).offset(8)
            make.left.equalTo(self.likeButton)
        }
        self.dotLabel.snp.makeConstraints { make in
            make.left.equalTo(self.titleLabel.snp.right).offset(3)
            make.centerY.equalTo(self.titleLabel)
        }
        self.describeLabel.snp.makeConstraints { make in
            make.left.equalTo(self.dotLabel.snp.right).offset(3)
            make.centerY.equalTo(self.titleLabel)
            make.bottom.equalTo(-10)
        }
    }

    // MARK: - 私有属性
    private lazy var nameLabel: UILabel = {
        let temp = UILabel()
        temp.text = "Larry_ikuzo"
        return temp
    }()

    private lazy var imageScrollView: ImageScrollView = {
        let temp = ImageScrollView()
        temp.showsVerticalScrollIndicator = false
        temp.showsHorizontalScrollIndicator = false
        return temp
    }()

    private lazy var pageControl: UIPageControl = {
        let temp = UIPageControl()
        temp.numberOfPages = 3
        return temp
    }()

    private lazy var likeButton: UIButton = {
        let temp = UIButton()
        temp.setBackgroundImage(UIImage(named: "like"), for: UIControlState())
        return temp
    }()

    private lazy var titleLabel: UILabel = {
        let temp = UILabel()
        temp.text = "Moment"
        return temp
    }()

    private lazy var dotLabel: UILabel = {
        let temp = UILabel()
        temp.text = "●"
        return temp
    }()

    private lazy var describeLabel: UILabel = {
        let temp = UILabel()
        temp.text = "We need to remember!"
        return temp
    }()
}
