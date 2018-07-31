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
    var foodItems = [FoodItemViewModel]()
    var pickItems = [NewPickItem]()
    var viewControllers = [IconViewController]()
    
    // MARK : - UI
    let categoryLabel = UILabel()
    var pagingViewController = CustomPagingViewController()
    var collectionView: UICollectionView!
    let submitButton = UIButton()
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        bindUI()
        setupPageView()
        constraintUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func addItem(_ sender: Any) {
        //postItem()
    }
    
}

fileprivate extension SelectedViewController {
    
    func initUI() {
        
        tabBarController?.tabBar.isHidden = true
        view.backgroundColor = pinkBackground
        
        categoryLabel.setup(textAlignment: .center, fontSize: 16, textColor: grayColor)
        
        submitButton.setup(title: "加入購物車", textColor: .black)
        submitButton.addTarget(self, action: #selector(addItem(_:)), for: .touchUpInside)
        
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
            $0.centerX.equalTo(categoryLabel.snp.centerX)
            $0.bottom.equalToSuperview().offset(-15)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(pagingViewController.view.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalTo(submitButton.snp.top).offset(-15)
        }
    }
    
    func setupPageView() {
        
        viewModel.foodItems.asObservable()
            .subscribe(onNext:{ [weak self] products in
                
                guard let `self` = self else { return }

                self.foodItems = products
                self.viewControllers = products.map{ IconViewController(foodName: $0.name, foodId: $0.id) }
                
                let currentIndex = self.viewModel.gbButtomIndex.value
                let index = self.pickItems[currentIndex].index
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
                
                items.forEach { item in
                    let newPickItem = NewPickItem(count: String(item.count), foodId: String(0))
                    self?.pickItems.append(newPickItem)
                }
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
        
        collectionView.rx.modelSelected(GiftBoxViewModel.self)
            .bind(to: viewModel.tapBtnCell)
            .disposed(by: rx.disposeBag)
        
        viewModel.currentCategoryName
            .drive(categoryLabel.rx.text)
            .disposed(by: rx.disposeBag)
    }
    
    func alertMessage(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.show(self, sender: nil)
    }
    
    func postItem() {
        viewModel.product
            .subscribe(onNext:{ [unowned self] p in
                let count = "1"
                let subtotal = String(p.price)
                let cartId = "1"
                let productId = String(p.id)
                
                let newCartItem = NewCartItem(count: count, subtotal: subtotal, cartId: cartId, productId: productId, pickedItems: self.pickItems)
                
                let services: APIDelegate = APIClient.sharedAPI
                
                services.addItem(item: newCartItem)
                    .subscribe(onNext:{ [unowned self] bool in
                        if bool == true {
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    })
                    .disposed(by: self.rx.disposeBag)
            })
            .disposed(by: rx.disposeBag)
    }
}


extension SelectedViewController: PagingViewControllerDelegate {

    func pagingViewController<T>(
        _ pagingViewController: PagingViewController<T>,
        didScrollToItem pagingItem: T,
        startingViewController: UIViewController?,
        destinationViewController: UIViewController, transitionSuccessful: Bool) {

        if transitionSuccessful {

            if let selectedIndex = self.pagingViewController.selectedIndex {
                let btmIndex = self.viewModel.gbButtomIndex.value
                
                guard let cell = collectionView
                    .cellForItem(at: IndexPath(row: btmIndex, section: 0)) as? DetailCollectionViewCell else {return}
                
                pickItems[btmIndex].index = selectedIndex
                pickItems[btmIndex].foodId = String(foodItems[self.pickItems[btmIndex].index].id)
                
                cell.textLabel.text = foodItems[pickItems[btmIndex].index].name

            }
        }

    }
}
