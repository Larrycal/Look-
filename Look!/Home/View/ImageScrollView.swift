//
//  ImageScrollView.swift
//  Look!
//
//  Created by 柳钰柯 on 2018/4/2.
//  Copyright © 2018年 Larry. All rights reserved.
//

import UIKit
import SnapKit

class ImageScrollView: UIScrollView {
    // MARK: - 公共属性
//    var images: [String]? {
//        didSet {
//            if images != nil && images!.count > 0 {
//                self.setup()
//            }
//        }
//    }
    
    // MARK: - 生命周期以及重载函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let imageView = UIImageView(image: UIImage(named: "IMG_5917"))
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 280)
//        imageView.contentMode = .scaleAspectFill
        self.addSubview(imageView)
    }
    // TODO: 图片大小识别和判断

}
