//
// HomeTableViewController.swift
// Look!
//
// Created by 柳钰柯 on 2018/3/16.
// Copyright (c) 2018 Larry. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class HomeTableViewController: BaseBouncedTableViewController {
    
    override func viewDidLoad() {
        self.setup()
    }
    
    private func setup() {
        self.tableView.backgroundColor = UIColor.white
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

    // MARK: - UITableViewDelegate
    
    
    
}
