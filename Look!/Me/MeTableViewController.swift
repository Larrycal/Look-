//
//  MeTableViewController.swift
//  Look!
//
//  Created by 柳钰柯 on 2018/3/26.
//  Copyright © 2018年 Larry. All rights reserved.
//

import UIKit

class MeTableViewController: BaseBouncedTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.lightGray
        self.tableView.layer.cornerRadius = 20
        self.tableView.separatorStyle = .none
    }

    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
 


}
