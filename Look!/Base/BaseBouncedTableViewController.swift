//
//  BaseBouncedTableViewController.swift
//  Look!
//
//  Created by 柳钰柯 on 2018/3/26.
//  Copyright © 2018年 Larry. All rights reserved.
//

import UIKit
import AudioToolbox

private let bouncedMinimumValue: CGFloat = 150
let baseBouncedTableViewMaxY: CGFloat = 190
let baseBouncedTableViewMinY: CGFloat = 96

class BaseBouncedTableViewController: UITableViewController {

    var bouncedDownHandler: ((_ bouncedView: UIView) -> Void)?
    var bouncedUpHandler: ((_ bouncedView: UIView) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - UIScrollViewDelegate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 向下拉
        if scrollView.contentOffset.y < 0 && self.view.y < bouncedMinimumValue {
            if self.isDownDecelerating {
                return
            }
            // scrollView.contentOffset.y*2 为了增加下拉难度
            self.view.y = (self.view.y - scrollView.contentOffset.y) >= bouncedMinimumValue ? bouncedMinimumValue : (self.view.y - scrollView.contentOffset.y)
            if self.view.y == bouncedMinimumValue {
                AudioServicesPlaySystemSound(1519)
                self.bouncedDownHandler?(self.view)
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 2, options: .curveEaseInOut, animations: {
                    self.view.y = baseBouncedTableViewMaxY
                }) { (finish) in
                }
            }
        }
        // 向上推
        if scrollView.contentOffset.y > 0 && self.view.y >= bouncedMinimumValue {
            self.view.y = (self.view.y - scrollView.contentOffset.y) <= bouncedMinimumValue ? bouncedMinimumValue : (self.view.y - scrollView.contentOffset.y)
            if self.view.y == bouncedMinimumValue {
                AudioServicesPlaySystemSound(1519)
                self.bouncedUpHandler?(self.view)
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 2, options: .curveEaseInOut, animations: {
                    self.view.y = baseBouncedTableViewMinY
                }) { (finish) in
                }
            }
        }
    }

    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.isDownDecelerating = true
    }

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.isDownDecelerating = false
    }

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 当不满足界面上升条件时、弹回原处
        if self.view.y >= bouncedMinimumValue && self.view.y != baseBouncedTableViewMinY && self.view.y != baseBouncedTableViewMaxY  {
            self.bouncedDownHandler?(self.view)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
                self.view.y = baseBouncedTableViewMaxY
            }) { (finish) in
            }
        } else if self.view.y < bouncedMinimumValue && self.view.y != baseBouncedTableViewMinY && self.view.y != baseBouncedTableViewMaxY {
            self.bouncedUpHandler?(self.view)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
                self.view.y = baseBouncedTableViewMinY
            }) { (finish) in
            }
        }
    }

    private var isDownDecelerating = false

}
