//
//  CartViewController.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/4/15.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable
import RxDataSources
import SnapKit

class CartViewController: UIViewController {
    
    // MARK : - UI
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.backgroundColor = pinkBackground
        tv.dataSource = self
        tv.delegate = self
        tv.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        tv.register(cellType: CartCell.self)
        tv.separatorStyle = .none
        view.addSubview(tv)
        return tv
    }()
    
    lazy var footerView: CartFooterView = {
        let footer = CartFooterView()
        footer.setupUI(buttonTitle: "結帳")
        view.addSubview(footer)
        
        return footer
    }()
    
    // MARK: - ViewModel
    var viewModel: CartViewModel!

    // MARK: - Properties
    var sections = [CartItem]()
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        setupBinding()
        constraintUI()
    }
}

extension CartViewController {

    func initUI() {
        view.backgroundColor = pinkBackground
        tableView.estimatedRowHeight = 65.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func setupBinding() {
        
        viewModel.totalPrice
            .subscribe(onNext:{ [unowned self] price in
                self.footerView.subtotalLabel.text = price
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.cartSections
            .subscribe(onNext:{ [unowned self] sections in
                self.sections = sections
                self.tableView.reloadData()
            })
            .disposed(by: rx.disposeBag)
        
        footerView.checkoutButton.rx.tap
            .subscribe(onNext:{ [unowned self] _ in
                self.viewModel.goProductList()
            })
            .disposed(by: rx.disposeBag)
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
}

extension CartViewController: UITableViewDataSource {
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


extension CartViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cartItem = sections[indexPath.section]
        
        guard let cell = tableView.cellForRow(at: indexPath) as? CartCell,
              let item = cell.item,
              let categoryId = item.food.foodCategoryId else { return }
        
        let vc = ExchangeViewController()
        vc.viewModel = ExchangeViewModel(categoryId: categoryId)
        vc.currentIndexPath = indexPath
        vc.cartItem = cartItem
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (sections[indexPath.section].expanded) {
            return 65
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let header = CartExpandView()
        header.setupUI(cartItem: sections[section], section: section, delegate: self)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 180.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = pinkBackground
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    

}

extension CartViewController: BaseExpandable {
    
    func deleteSection(section: Int) {
        
        self.sections.remove(at: section)
        
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.deleteSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
            self.tableView.endUpdates()
            self.tableView.reloadData()
        }
    }
    
    func toggleSection(header: BaseExpandView, section: Int) {
        
        if sections.count != 0 {
            sections[section].expanded = !sections[section].expanded
            
            tableView.beginUpdates()
            for i in 0 ..< sections[section].pickedItem.count {
                tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
            }
            tableView.endUpdates()
        }

    }
    
    func showAlert(alertController: UIAlertController) {
        present(alertController, animated: true, completion: nil)
    }
    
    func reloadData() {
        
        viewModel.cartSections
            .subscribe(onNext:{ [unowned self] sections in
                
                let total = sections.map{$0.subtotal}.reduce(0, {$0 + $1})
                print(total)
                self.sections = sections
                self.tableView.reloadData()
                self.footerView.subtotalLabel.text = "$\(total)"
            })
            .disposed(by: rx.disposeBag)
    }
}

extension CartViewController: ExchangeDelegate {
    
    func reloadItems(indexPath: IndexPath) {
        viewModel.cartSections
            .subscribe(onNext:{ [unowned self] sections in
                self.sections = sections
                self.tableView.reloadData()
            })
            .disposed(by: rx.disposeBag)
    }
}

