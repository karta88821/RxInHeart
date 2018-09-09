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
    
    // MARK: - ViewModel
    var viewModel: CartViewModel!
    
    // MARK : - UI
    var tableView: UITableView!
    var footerView: CartFooterView!
    lazy var loadingView: UIView = {
        let loadView = UIView()
        loadView.backgroundColor = pinkBackground
        
        let ai = UIActivityIndicatorView()
        ai.startAnimating()
        ai.activityIndicatorViewStyle = .gray
        ai.sizeToFit()
        
        let label = UILabel(alignment: .center, fontSize: 14, text: "載入中請稍候...")
        label.frame = CGRect(
            x: 0,
            y: 0,
            width: view.bounds.size.width,
            height: view.bounds.size.height
        )

        label.sizeToFit()
        
        loadView.addSubViews(views: ai, label)
        
        ai.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(ai.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
        }
        
        return loadView
    }()
    
    // MARK: - Properties
    var sections = [CartItem]()
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        createViews()
        bindUI()
        constraintUI()
    }
}

extension CartViewController {
    
    func createViews() {
        configureTableView()
        configureFooterView()
        configureView(for: view)
    }
    
    func configureView(for view: UIView) {
        view.backgroundColor = pinkBackground
        view.addSubViews(views: tableView, footerView)
    }
    
    func configureTableView() {
        tableView = {
            let tv = UITableView(frame: .zero, style: .grouped)
            tv.backgroundColor = pinkBackground
            tv.dataSource = self
            tv.delegate = self
            tv.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
            tv.register(CartExpandView.self, forHeaderFooterViewReuseIdentifier: "CartExpandView")
            tv.register(cellType: CartCell.self)
            tv.separatorStyle = .none
            
            tv.estimatedRowHeight = 65.0
            tv.rowHeight = UITableViewAutomaticDimension
            
            return tv
        }()
    }
    
    func configureFooterView() {
        footerView = {
            let footer = CartFooterView()
            footer.setupUI(buttonTitle: "結帳")
            return footer
        }()
    }
    
    func bindUI() {
        viewModel.totalPrice
            .subscribe(onNext:{ [weak self] price in
                self?.footerView.subtotalLabel.text = price
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.cartSections.asObservable()
            .subscribe(onNext:{ [weak self] sections in
                self?.sections = sections
                self?.tableView.reloadData()
            })
            .disposed(by: rx.disposeBag)
        
        footerView.checkoutButton.rx.tap
            .subscribe(onNext:{ [weak self] _ in
                self?.viewModel.goProductList()
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
        if sections.count > 0 {
            tableView.backgroundView = nil
            return sections.count
        } else {
            tableView.backgroundView = loadingView
        }
        return 0
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
              let foodCategoryId = item.food?.foodCategoryId  else { return }
        
        let vc = ExchangeViewController()
        vc.viewModel = ExchangeViewModel(categoryId: foodCategoryId, services: self.viewModel.services)
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

        let header = CartExpandView(reuseIdentifier: "CartExpandView", services: self.viewModel.services)
        header.setupUI(cartItem: sections[section], section: section, delegate: self)
        header.cartDelegate = self
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
    func toggleSection(header: BaseExpandableView, section: Int) {
        
        if sections.count != 0 {
            sections[section].expanded = !sections[section].expanded
            
            tableView.beginUpdates()
            for i in 0 ..< sections[section].pickedItem.count {
                tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .fade)
            }
            tableView.endUpdates()
        }
        
    }
}

extension CartViewController: CartRequired {
    
    func deleteSection(section: Int) {
        
        self.sections.remove(at: section)
        
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.deleteSections(NSIndexSet(index: section) as IndexSet, with: UITableViewRowAnimation.fade)
            self.tableView.endUpdates()
        }
    }
    
    func showAlert(alertController: UIAlertController) {
        present(alertController, animated: true, completion: nil)
    }
    
    func reloadData() {
        viewModel.cartSections.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:{ [weak self] sections in
                let total = sections.map{$0.subtotal}.reduce(0, {$0 + $1})
                self?.sections = sections
                self?.tableView.reloadData()
                self?.footerView.subtotalLabel.text = "$\(total)"
            })
            .disposed(by: rx.disposeBag)
    }
}

extension CartViewController: ExchangeDelegate {
    
    func reloadItems(indexPath: IndexPath) {
        viewModel.cartSections.asObservable()
            .subscribe(onNext:{ [weak self] sections in
                
                self?.sections = sections
                self?.tableView.reloadData()
            })
            .disposed(by: rx.disposeBag)
    }
}

