//
//  ExchangeViewController.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/25.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import SnapKit
import Kingfisher

protocol ExchangeDelegate {
    func reloadItems(indexPath: IndexPath)
}

class ExchangeViewController: UIViewController {
    
    // MARK : - Properties
    var collectionView: UICollectionView!
    var viewModel: ExchangeViewModel!
    var cartItem: CartItem!
    var currentIndexPath: IndexPath!
    var delegate: ExchangeDelegate?
    let dismissButton = UIButton()
    
    // MARK : - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        constraintUI()
        setupBinding()
    }
    
    func setupBinding() {
        
        viewModel.foods
            .bind(to: collectionView.rx.items(cellIdentifier: "collectionCell", cellType: FoodsCollectionViewCell.self)) { (row, element, cell) in
                cell.food = element
                cell.setImage(id: element.getId())
                cell.foodLabel.text = element.getName()
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(Food_cart.self)
            .subscribe(onNext:{ [unowned self] food in
                
                var pickItems = self.cartItem.getPickItems().map { PickedItem_cart(id: $0.getId(), count: $0.getCount(), foodId: $0.getFoodId(), cartItemId: $0.getCartItemId())}
                
                pickItems[self.currentIndexPath.row].foodId = food.getId()
                
                let item = CartItem(id: self.cartItem.getId(), count: self.cartItem.getCount(), subtotal: self.cartItem.getSubtotal(), pickedItem: pickItems, productId: self.cartItem.getProductId(), cartId: self.cartItem.getCartId())
                
                self.viewModel.services.updateItem(cartItemId: self.cartItem.getId(), item: item)
                    .subscribe(onNext:{ bool in
                        if bool == true {
                            self.dismiss(animated: true, completion: nil)
                            self.delegate?.reloadItems(indexPath: self.currentIndexPath)
                        }
                    })
                    .disposed(by: self.rx.disposeBag)
            })
            .disposed(by: rx.disposeBag)
        
    }
}

private extension ExchangeViewController {
    
    func setupUI() {
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0,
                                                        width: view.frame.size.width,
                                                        height: view.frame.size.height - 150),
                                          collectionViewLayout: FoodsFlowLayout())
        collectionView.backgroundColor = UIColor.white
        collectionView.register(FoodsCollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        
        dismissButton.setTitle("返回", for: .normal)
        dismissButton.setTitleColor(.blue, for: .normal)
        dismissButton.addTarget(self, action: #selector(dismiss(_:)), for: .touchUpInside)
        
        view.addSubview(collectionView)
        view.addSubview(dismissButton)
        view.backgroundColor = .white
    }
    
    func constraintUI() {
        dismissButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(30)
        }
    }
    
    @objc func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
