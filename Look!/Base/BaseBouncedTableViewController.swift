//
//  BaseBouncedTableViewController.swift
//  Look!
//
//  Created by 柳钰柯 on 2018/3/26.
//  Copyright © 2018年 Larry. All rights reserved.
//

import UIKit
import AudioToolbox

private let bouncedMinimumValue:CGFloat = 150
class BaseBouncedTableViewController: UITableViewController {

    var bouncedDownHandler:((_ scrollView:UIScrollView, _ bouncedView:UIView)->Void)?
    var bouncedUpHandler:((_ scrollView:UIScrollView, _ bouncedView:UIView)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - UIScrollViewDelegate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 向下拉
        if scrollView.contentOffset.y < 0 && self.view.y < bouncedMinimumValue{
            self.view.y = (self.view.y - scrollView.contentOffset.y) >= bouncedMinimumValue ? bouncedMinimumValue:(self.view.y - scrollView.contentOffset.y)
            if self.view.y == bouncedMinimumValue {
                if !self.peeked {
                    self.peeked = true
                    AudioServicesPlaySystemSound(1519)
                }
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 2, options: .curveEaseInOut, animations: {
                    self.view.y = 190
                }) { (finish) in
                    self.bouncedDownHandler?(scrollView,self.view)
                }
            }
        }
        // 向上推
        if scrollView.contentOffset.y > 0 && self.view.y > bouncedMinimumValue{
            self.view.y = (self.view.y - scrollView.contentOffset.y) <= bouncedMinimumValue ? bouncedMinimumValue:(self.view.y - scrollView.contentOffset.y)
            if self.peeked {
                self.peeked = false
                AudioServicesPlaySystemSound(1519)
            }
            if self.view.y == bouncedMinimumValue {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 2, options: .curveEaseInOut, animations: {
                    self.view.y = 96
                }) { (finish) in
                    self.bouncedUpHandler?(scrollView,self.view)
                }
            }
        }
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 当不满足界面上升条件时、弹回原处
        if self.view.y >= bouncedMinimumValue {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
                self.view.y = 190
            }) { (finish) in
                self.bouncedDownHandler?(scrollView,self.view)
            }
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
                self.view.y = 96
            }) { (finish) in
                self.bouncedUpHandler?(scrollView,self.view)
            }
        }
    }
    
    private lazy var peeked:Bool = false

}
