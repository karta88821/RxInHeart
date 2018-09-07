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

let estimatedHeight: CGFloat = 380

class MainViewController: UIViewController {
    
    // MARK : - UI
    var tableView: UITableView!
    var headerView: UIView!
    var activityIndicator: UIActivityIndicatorView!
    var activityLabel: UILabel!

    // MARK: - ViewModel
    var viewModel: MainViewModel!
    var expandedCellPaths = Set<IndexPath>()

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        createViews()
        bindUI()
        constraintUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = true
    }
}

fileprivate extension MainViewController {
    
    func createViews() {
        configureTableView()
        configureTableViewHeaderView()
        configureLoadingView()
        configureView(for: view)
    }
    
    func configureTableView() {
        tableView = {
            let tv = UITableView(frame: .zero)
            tv.register(cellType: MainTableViewCell.self)
            tv.showsVerticalScrollIndicator = false
            tv.separatorStyle = .singleLine
            tv.backgroundColor = .white
            
            tv.rowHeight = UITableViewAutomaticDimension
            tv.estimatedRowHeight = estimatedHeight
            
            tv.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            tv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tabBarHight, right: 0)
            
            return tv
        }()
    }
    
    func configureTableViewHeaderView() {
        headerView = {
            let headerFrame = CGRect(x: 0, y: 0, width: screenWidth, height: 60)
            let header = UIView(frame: headerFrame)
            header.backgroundColor = .white
            
            let label = UILabel(alignment: .left, fontSize: 20, text: "客製化禮盒")
            header.addSubview(label)
            label.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalToSuperview().offset(20)
            }
            return header
        }()
        
        self.tableView.tableHeaderView = headerView
    }
    
    func configureLoadingView() {
        activityIndicator = {
            let ai = UIActivityIndicatorView()
            ai.startAnimating()
            ai.activityIndicatorViewStyle = .gray
            return ai
        }()
        
        activityLabel = UILabel(alignment: .center, fontSize: 14, text: "載入中請稍候...")
    }
    
    func configureView(for view: UIView) {
        view.backgroundColor = .white
        addSubviews(to: view)
    }
    
    func addSubviews(to view: UIView) {
        view.addSubview(tableView)
        view.insertSubview(activityIndicator, belowSubview: tableView)
        view.insertSubview(activityLabel, belowSubview: tableView)
    }

    func bindUI() {
        viewModel.databaseIsEmpty.asObservable()
            .subscribe(onNext:{ [weak self] bool in
                self?.tableView.isHidden = bool
            }).disposed(by: rx.disposeBag)

        viewModel.start()
        
        viewModel.products.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "MainTableViewCell", cellType: MainTableViewCell.self)) { [unowned self] (row, element, cell) in
                let indexPath = IndexPath(row: row, section: 0)
                cell.product = element
                
                cell.setupCollectionView(with: Observable.just(element.caseModels), and: row)
                cell.expandableView.isHidden = !self.expandedCellPaths.contains(indexPath)
                
                cell.collectionView.rx.itemSelected
                    .subscribe(onNext:{ [weak self] cvIndexPath in
                        
                        guard let cell = self?.tableView.cellForRow(at: indexPath) as? MainTableViewCell,
                              let cvCell = cell.collectionView.cellForItem(at: cvIndexPath) as? MainCollectionViewCell,
                              let products = cvCell.caseModel?.products else {
                              fatalError("❌ Tap collectionView cell action failed!")
                        }
                        
                        cell.setupPageView(with: products)
                        cell.viewControllers.forEach{ $0.delegate = self }
                        cell.expandView()
                        //cell.expandableView.isHidden = !cell.expandableView.isHidden
                        
                        if cell.expandableView.isHidden {
                            self?.expandedCellPaths.remove(indexPath)
                        } else {
                            self?.expandedCellPaths.insert(indexPath)
                        }
                        self?.tableView.beginUpdates()
                        self?.tableView.endUpdates()
                        self?.tableView.deselectRow(at: indexPath, animated: true)
                    })
                    .disposed(by: cell.disposeBag)
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

extension MainViewController: ContentViewDelegate {
    func push(id: Int) {
        viewModel.pick(compositionId: id)
    }
}
