//
//  AccountViewController.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/3/2.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import Reusable

class AccountViewController: UIViewController, AccountRequired {
    
    var viewModel: AccountViewModel!
    
    let logoutView = LogoutView()
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero)
        tv.backgroundColor = pinkBackground
        tv.showsVerticalScrollIndicator = false
        tv.isScrollEnabled = false
        tv.separatorStyle = .none
        tv.delegate = self
        tv.dataSource = self
        tv.register(cellType: AccountCell.self)
        return tv
    }()
    
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
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.push(with: indexPath.row)
    }
}

private extension AccountViewController {
    func initUI() {
        view.backgroundColor = pinkBackground
        view.addSubViews(views: logoutView, tableView)
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
