//
//  CartExpandView.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/30.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

protocol CartRequired: class {
    func reloadData()
    func deleteSection(section: Int)
    func showAlert(alertController: UIAlertController)
}

class CartExpandView: BaseCartItemExpandableView {
    
    // MARK : - UI
    var deleteButton: UIButton!
    var plusButton: UIButton!
    var countLabel: UILabel!
    var minusButton: UIButton!
    
    // MARK : - Services
    let services: AppServices
    
    // MARK : - CartDelegate
    weak var cartDelegate: CartRequired?
    
    init(reuseIdentifier: String?, services: AppServices) {
        self.services = services
        super.init(reuseIdentifier: reuseIdentifier)
        configureView()
        constraintUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        plusButton.makeCircle()
        minusButton.makeCircle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupUI(cartItem: CartItem, section: Int, delegate: BaseExpandable) {
        super.setupUI(cartItem: cartItem, section: section, delegate: delegate)
        countLabel.text = String(item.count)
    }
}

extension CartExpandView {
    @objc func plusAction(_ sender: UIButton) {
        services.cartService
            .updateItem(cartItemId: item.id, item: addItem())
            .subscribe(onNext:{ [unowned self] bool in
                if bool == true {
                    self.cartDelegate?.reloadData()
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
    @objc func minusAction(_ sender: UIButton) {
        if item.count > 1 {
            services.cartService
                .updateItem(cartItemId: item.id, item: minusItem())
                .subscribe(onNext:{ [unowned self] bool in
                    if bool == true {
                        self.cartDelegate?.reloadData()
                    }
                })
                .disposed(by: rx.disposeBag)
        }

    }
    
    @objc func deleteSection(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "購物車", message: "確定要刪除此產品嗎？", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        let okAction = UIAlertAction(title: "確定", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            
            self.services.cartService
                .deleteItem(cartItemId: self.item.id)
                .subscribe(onNext:{ [weak self] bool in
                    guard let this = self else { return }
                    if bool {
                        this.cartDelegate?.deleteSection(section: this.section)
                    }
                })
                .disposed(by: self.rx.disposeBag)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        cartDelegate?.showAlert(alertController: alertController)
    }
    
    //    func setCollapsed(_ collapsed: Bool) {
    //        arrowLabel.rotate(collapsed ? 0.0 : .pi / 2)
    //    }
}

private extension CartExpandView {
    
    func createViews() {
        configureDeleteButton()
        configurePlusButton()
        configureCountLabel()
        configureMinusButton()
    }
    
    func configureView() {
        createViews()
        addSubViews(views: deleteButton, plusButton, countLabel, minusButton)
    }
    
    func configureDeleteButton() {
         deleteButton = {
            let button = UIButton()
            button.setAttributedTitle(NSAttributedString(string: "刪除",
                                                         attributes: [.font: UIFont.systemFont(ofSize: 16),
                                                                      .foregroundColor: pinkButtonBg!]), for: .normal)
            button.addTarget(self, action: #selector(deleteSection(_:)), for: .touchUpInside)
            return button
        }()
    }
    
    func configurePlusButton() {
        plusButton = {
            let button = UIButton()
            button.backgroundColor = .white
            button.setup(title: "+", textColor: .black)
            button.makeBorder(width: 1.0)
            button.addTarget(self, action: #selector(plusAction(_:)), for: .touchUpInside)
            return button
        }()
    }
    
    func configureCountLabel() {
        countLabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.textColor = .black
            label.makeBorder(width: 1.0)
            return label
        }()
    }
    
    func configureMinusButton() {
        minusButton = {
            let button = UIButton()
            button.setup(title: "-", textColor: .black)
            button.makeBorder(width: 1.0)
            button.backgroundColor = .white
            button.addTarget(self, action: #selector(minusAction(_:)), for: .touchUpInside)
            return button
        }()
    }
    
    func constraintUI() {
        deleteButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(5)
        }
        
        plusButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-40)
            make.right.equalToSuperview().inset(20)
            make.width.height.equalTo(30)
        }
        
        countLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(5)
            make.right.equalTo(plusButton.snp.right).offset(5)
            make.width.equalTo(40)
            make.height.equalTo(30)
        }
        
        minusButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(50)
            make.right.equalTo(plusButton.snp.right)
            make.width.height.equalTo(30)
        }
    }
    
    func addItem() -> CartItem {
        let addCount = item.count + 1
        let addSubtotal = addCount * item.product.price
        return CartItem(id: item.id, count: addCount, subtotal: addSubtotal, pickedItem: item.pickedItem, productId: item.productId, cartId: item.cartId)
    }
    
    func minusItem() -> CartItem {
        let minusCount = item.count - 1
        let minusSubtotal = minusCount * item.product.price
        return CartItem(id: item.id, count: minusCount, subtotal: minusSubtotal, pickedItem: item.pickedItem, productId: item.productId, cartId: item.cartId)
    }
}

