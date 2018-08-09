//
//  ProductListController.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/28.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import Reusable
import SnapKit
import RxSwift
import RxCocoa


class ProductListController: UIViewController {
    
    // MARK : - ViewModel
    var viewModel: ProductListViewModel!
    
    // MARK : - Properties
    var sections = [CartItem]()
    
    // MARK : - Subviews
    var tableView: UITableView!
    let footerView = CartFooterView()
    
    // MARK : - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        constraintUI()
        bindUI()
    }
}

private extension ProductListController {
    
    func initUI() {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = pinkBackground
        tableView.separatorStyle = .none
        tableView.register(cellType: CartCell.self)
        tableView.contentInset = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        
        let headerView = BaseAxisView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 75))
        tableView.tableHeaderView = headerView
        
        self.tableView = tableView
        
        footerView.setupUI(buttonTitle: "NEXT")

        view.backgroundColor = pinkBackground
        view.addSubViews(views: self.tableView, footerView)
    }
    
    func constraintUI() {
        
        footerView.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.height.equalTo(150)
        }
        
        tableView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.bottom.equalTo(footerView.snp.top)
        }
    }
    
    func bindUI() {
        
        viewModel.cartSections
            .subscribe(onNext:{ [unowned self] sections in
                self.sections = sections
                self.tableView.reloadData()
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.totalPrice
            .subscribe(onNext:{ [unowned self] price in
                self.footerView.subtotalLabel.text = price
            })
            .disposed(by: rx.disposeBag)
        
        footerView.checkoutButton.rx.tap
            .subscribe(onNext:{ [unowned self] _ in
                self.viewModel.goForm()
            })
            .disposed(by: rx.disposeBag)
    }
}

extension ProductListController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as CartCell
        let item = sections[indexPath.section].items[indexPath.row]
        cell.item = item
        cell.expaned = sections[indexPath.section].expanded
        
        return cell
    }
}

extension ProductListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[indexPath.section].expanded ? 65 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = BaseExpandView()
        if sections.count != 0 {
            header.setupUI(cartItem: sections[section], section: section, delegate: self)
            
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 180.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
}

extension ProductListController: BaseExpandable {
    func toggleSection(header: BaseExpandView, section: Int) {
        
        sections[section].expanded = !sections[section].expanded
            
        tableView.beginUpdates()
        for i in 0 ..< sections[section].getPickItems().count {
            tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        tableView.endUpdates()
    }
}
