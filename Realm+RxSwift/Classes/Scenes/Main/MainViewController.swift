//
//  MainViewController.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/3/2.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable
import NSObject_Rx

class MainViewController: UIViewController {
    
    // MARK: - UI
    var tableView: UITableView!
    
    // MARK: - ViewModel
    var viewModel: MainViewModel!
    
    // MARK: - Property
    var selectedIndex = -1

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        bindUI()
        constraintUI()
    }
}

fileprivate extension MainViewController {
    
    func initUI() {
        
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: "MainTableViewCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 380
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 60))
        headerView.backgroundColor = .white
        let headerLabel = UILabel()
        headerLabel.setupWithTitle(textAlignment: .left, fontSize: 20, textColor: grayColor, text: "客製化禮盒")
        headerView.addSubview(headerLabel)
        headerLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        tableView.tableHeaderView = headerView
        
        self.tableView = tableView

        view.addSubview(self.tableView)
    }
    
    func bindUI() {

        viewModel.products
            .bind(to: tableView.rx.items(cellIdentifier: "MainTableViewCell", cellType: MainTableViewCell.self)) { [weak self] row, item, cell in
                guard let `self` = self else { return }
                let indexPath = IndexPath(row: row, section: 0)

                cell.product = item

                guard let collectionView = cell.collectionView else { return }

                Observable.just(item.caseModels)
                    .bind(to: collectionView.rx.items(cellIdentifier: "MainCollectionViewCell", cellType: MainCollectionViewCell.self)) { _row, _item, _cell in
                        _cell.caseModel = _item
                    }
                    .disposed(by: cell.rx.disposeBag)

                collectionView.rx
                    .modelSelected(CaseModel.self)
                    .bind(to: self.viewModel.selectCase)
                    .disposed(by: cell.rx.disposeBag)

                self.viewModel.currentGiftBoxItems
                    .subscribe(onNext:{ products in

                        cell.products.value = products
                        cell.viewControllers.forEach { viewController in
                            viewController.delegate = self
                        }
                    })
                    .disposed(by: self.rx.disposeBag)

                // click collectionViewCell to expand view
                collectionView.rx.itemSelected
                    .subscribe(onNext:{ [weak self] cIndexPath in

                        self?.selectedIndex = (self?.selectedIndex == indexPath.row ) ? -1 : indexPath.row

                        self?.tableView.beginUpdates()
                        self?.tableView.endUpdates()
                    })
                    .disposed(by: cell.rx.disposeBag)
            }
            .disposed(by: rx.disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: rx.disposeBag)
    }

    func constraintUI() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func downloadDataBase() {
        apiProvider.rx.request(.foods)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .mapArray(FoodEntity.self)
            .subscribe(onSuccess: { response in
                DBManager.write(response)
            },onError: { error in
                print("数据请求失败!错误原因：", error)
            }).disposed(by: disposeBag)
        
        print(DBManager.fileUrl())
        
        apiProvider.rx.request(.products)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .mapArray(ProductEntity.self)
            .subscribe(onSuccess: { response in
                print(response)
                DBManager.write(response)
                
            },onError: { error in
                print("数据请求失败!错误原因：", error)
            }).disposed(by: disposeBag)
    }
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndex == indexPath.row {
            return 380
        } else {
            return 210
        }
    }
}

extension MainViewController: ContentViewDelegate {
    func push(id: Int) {
        viewModel.pick(compositionId: id)
    }
}
