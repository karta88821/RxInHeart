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
    
    // MARK : - UI
    var tableView: UITableView!
    
    lazy var headerView: UIView = {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 60))
        header.backgroundColor = .white
        let label = UILabel()
        label.setupWithTitle(textAlignment: .left, fontSize: 20, textColor: grayColor, text: "客製化禮盒")
        header.addSubview(label)
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        return header
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.startAnimating()
        ai.activityIndicatorViewStyle = .gray
        view.insertSubview(ai, belowSubview: tableView)
        return ai
    }()
    
    lazy var activityLabel: UILabel = {
        let label = UILabel()
        label.setupWithTitle(textAlignment: .center, fontSize: 14, textColor: grayColor, text: "載入中請稍候...")
        view.insertSubview(label, belowSubview: tableView)
        return label
    }()
    
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
        view.backgroundColor = .white
        //tableView.rowHeight = UITableViewAutomaticDimension
        let tv = UITableView(frame: .zero)
        tv.backgroundColor = .white
        tv.showsVerticalScrollIndicator = false
        tv.separatorStyle = .singleLine

        tv.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self.tabBarHight, right: 0)
        tv.register(MainTableViewCell.self, forCellReuseIdentifier: "MainTableViewCell")
        tv.tableHeaderView = headerView
        tv.estimatedRowHeight = 380
        tv.dataSource = nil
        tv.delegate = nil
        self.tableView = tv
        view.addSubview(tableView)
    }
    
    func bindUI() {
        
        viewModel.databaseIsEmpty.asObservable()
            .subscribe(onNext:{ [weak self] bool in
                self?.tableView.isHidden = bool
            }).disposed(by: rx.disposeBag)

        viewModel.start()
        
        tableView.rx.setDelegate(self)
            .disposed(by: rx.disposeBag)

        viewModel.products.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "MainTableViewCell", cellType: MainTableViewCell.self)) { [weak self] row, item, cell in
                
                guard let strongSelf = self else {return}
                
                let indexPath = IndexPath(row: row, section: 0)
                
                

                cell.product = item

                Observable.just(item.caseModels)
                    .bind(to: cell.collectionView.rx.items(cellIdentifier: "MainCollectionViewCell", cellType: MainCollectionViewCell.self)) { _row, _item, _cell in
                        _cell.caseModel = _item
                    }
                    .disposed(by: cell.rx.disposeBag)

                cell.collectionView.rx
                    .modelSelected(CaseModel.self)
                    .bind(to: strongSelf.viewModel.selectCase)
                    .disposed(by: cell.rx.disposeBag)

                strongSelf.viewModel.currentGiftBoxItems
                    .subscribe(onNext:{ products in

                        cell.products.value = products
                        cell.viewControllers.forEach { viewController in
                            viewController.delegate = self
                        }
                    })
                    .disposed(by: strongSelf.rx.disposeBag)

                // click collectionViewCell to expand view
                cell.collectionView.rx.itemSelected
                    .subscribe(onNext:{ [weak self] cIndexPath in
                        
                        let x = indexPath.row + cIndexPath.section
                        
                        //self?.selectedIndex = (self?.selectedIndex == indexPath.row ) ? -1 : indexPath.row
                        self?.selectedIndex = (self?.selectedIndex == x ) ? -1 : x
                        self?.tableView.beginUpdates()
                        self?.tableView.endUpdates()
                    })
                    .disposed(by: cell.rx.disposeBag)
            }
            .disposed(by: rx.disposeBag)
        
    }

    func constraintUI() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-50)
        }
        
        activityLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(activityIndicator.snp.bottom).offset(20)
        }
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
