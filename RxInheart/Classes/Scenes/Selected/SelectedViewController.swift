//
//  SelectedViewController.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/20.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable
import SnapKit
import Parchment

class SelectedViewController: UIViewController {
    
    // MARK: - ViewModel
    var viewModel: SelectedViewModel!
    
    // MARK: - Property
    var selectedIndex = -1
    var viewControllers = [IconViewController]()
    
    // MARK : - UI
    let categoryLabel = UILabel(alignment: .center, fontSize: 16)
    var pagingViewController = CustomPagingViewController()
    var collectionView: UICollectionView!
    var submitButton: UIButton!
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        createViews()
        bindUI()
        constraintUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func addItem(_ sender: Any) {
        postItem()
    }
}

fileprivate extension SelectedViewController {
    
    func createViews() {
        configureButton()
        configurePageView()
        configureView(for: view)
    }
    
    func configureButton() {
        submitButton = {
            let button = UIButton()
            button.makeShadow(cornerRadius: 20, shadowOpacity: 0.2, shadowOffsetH: 0.3)
            button.clipsToBounds = true
            button.backgroundColor = pinkButtonBg
            button.setup(title: "加入購物車", textColor: .white)
            button.addTarget(self, action: #selector(addItem(_:)), for: .touchUpInside)
            return button
        }()
    }
    
    func configureView(for view: UIView) {
        view.backgroundColor = pinkBackground
        view.addSubViews(views: categoryLabel, submitButton)
    }
    
    func constraintUI() {
        categoryLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(15)
        }
        
        pagingViewController.view.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(300)
        }
        
        submitButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(100)
            $0.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(35)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(pagingViewController.view.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalTo(submitButton.snp.top).offset(-20)
        }
    }
    
    func configurePageView() {
        viewModel.foodItems.asObservable()
            .subscribe(onNext:{ [weak self] products in
                
                guard let `self` = self else { return }

                self.viewControllers = products.map{ IconViewController(foodName: $0.name, foodId: $0.id) }
                
                let currentIndex = self.viewModel.gbButtomIndex.value
                let index = self.viewModel.pickItems.value[currentIndex].index
                let id = products[index].id
                
                let iconItem = IconItem(name: String(id), index: index)
                
                self.pagingViewController.configure(with: self.viewControllers)
                
                self.pagingViewController.reloadData(around: iconItem)
                self.pagingViewController.select(index: index)
                
                self.pagingViewController.didMove(toParentViewController: self)
                self.addChildViewController(self.pagingViewController)
            })
            .disposed(by: rx.disposeBag)

        pagingViewController.delegate = self

        view.addSubview(pagingViewController.view)
    }
    
    func bindUI() {
        viewModel.giftBoxItems.asObservable()
            .subscribe(onNext:{ [weak self] items in
                let layout = CustomLayout()
                layout.totalCount = items.count
                let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
                cv.isScrollEnabled = false
                cv.layer.masksToBounds = false
                cv.layer.cornerRadius = 5
                cv.backgroundColor = detailCollectionBg
                cv.contentInset = UIEdgeInsetsMake(10, 10, 10, 10)
                cv.register(cellType: DetailCollectionViewCell.self)

                self?.collectionView = cv
                self?.view.addSubview(cv)
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.giftBoxItems.asDriver()
            .drive(collectionView.rx.items) {(collectionView, row, element) in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = collectionView.dequeueReusableCell(for: indexPath) as DetailCollectionViewCell
                cell.itemModel = element
                
                return cell
            }
            .disposed(by: rx.disposeBag)
        
        collectionView.rx.itemSelected
            .map{$0.row}
            .bind(to: viewModel.gbButtomIndex)
            .disposed(by: rx.disposeBag)
        
        collectionView.rx.modelSelected(GiftboxItem.self)
            .bind(to: viewModel.tapBtnCell)
            .disposed(by: rx.disposeBag)
        
        viewModel.currentCategoryName
            .drive(categoryLabel.rx.text)
            .disposed(by: rx.disposeBag)
    }
    
    func alertMessage(title: String, message: String, action: UIAlertAction) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func postItem() {
        viewModel.addItem(success: { [weak self] (title, message) in
            let action = UIAlertAction(title: "確定", style: .default) {_ in
                DispatchQueue.main.async {
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            }
            self?.alertMessage(title: title, message: message, action: action)
            
        }, failure: { [weak self] (title, message) in
            let action = UIAlertAction(title: "確定", style: .default)
            self?.alertMessage(title: title, message: message, action: action)
        }, haventSelect: { [weak self] (title, message) in
            let action = UIAlertAction(title: "確定", style: .default)
            self?.alertMessage(title: title, message: message, action: action)
        })
    }
}


extension SelectedViewController: PagingViewControllerDelegate {
    func pagingViewController<T>(
        _ pagingViewController: PagingViewController<T>,
        didScrollToItem pagingItem: T,
        startingViewController: UIViewController?,
        destinationViewController: UIViewController, transitionSuccessful: Bool) {

        if transitionSuccessful {
            
            let btmIndex = self.viewModel.gbButtomIndex.value
            
            guard let selectedIndex = self.pagingViewController.selectedIndex,
                  let cell = collectionView.cellForItem(at: IndexPath(row: btmIndex, section: 0)) as? DetailCollectionViewCell else {return}
                viewModel.changeSection(index: selectedIndex)

                let foods = self.viewModel.foodItems.value
                cell.changeFoodText(to: foods[viewModel.pickItems.value[btmIndex].index].name)
        }

    }
}
