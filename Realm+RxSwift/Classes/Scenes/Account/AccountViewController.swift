//
//  AccountViewController.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/3/2.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import Reusable

class AccountViewController: UIViewController {
    
    var viewModel: AccountViewModel!
    
    let logoutView = LogoutView()
    var tableView: UITableView!
    
    private let titles = ["會員資料","訂單查詢","線上諮詢"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        constraintUI()
    }
}

extension AccountViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as AccountCell
        cell.title = titles[indexPath.row]
        return cell
    }
}

extension AccountViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.row == 0 {
            viewModel.goShoppingNote()
        } else if indexPath.row == 2 {
            viewModel.goShoppingNote()
        }
    }
}

private extension AccountViewController {
    func initUI() {
        view.backgroundColor = pinkBackground
        
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = pinkBackground
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: AccountCell.self)
        self.tableView = tableView
        
        view.addSubViews(views: logoutView, self.tableView)
    }
    
    func constraintUI() {
        logoutView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(200)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(logoutView.snp.bottom).offset(1)
            $0.left.bottom.right.equalToSuperview()
        }
    }
}
