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

class CartExpandView: BaseExpandView {
    
    let deleteButton = UIButton()
    let plusButton = UIButton()
    let countLabel = UILabel()
    let minusButton = UIButton()
    
    let services: APIDelegate = APIClient.sharedAPI
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initUI()
        constraintUI()
    }
    
    override func setupUI(cartItem: CartItem, section: Int, delegate: BaseExpandable) {
        super.setupUI(cartItem: cartItem, section: section, delegate: delegate)
        self.countLabel.text = String(item!.count)
    }
}

extension CartExpandView {
    @objc func plusAction(_ sender: UIButton) {
        services.updateItem(cartItemId: item.id, item: addItem())
            .subscribe(onNext:{ [unowned self] bool in
                if bool == true {
                    self.delegate?.reloadData!()
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
    @objc func minusAction(_ sender: UIButton) {
        services.updateItem(cartItemId: item.id, item: minusItem())
            .subscribe(onNext:{ [unowned self] bool in
                if bool == true {
                    self.delegate?.reloadData!()
                }
            })
            .disposed(by: rx.disposeBag)
    }
    //    func setCollapsed(_ collapsed: Bool) {
    //        arrowLabel.rotate(collapsed ? 0.0 : .pi / 2)
    //    }
    
    @objc func deleteSection(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "購物車", message: "確定要刪除此產品嗎？", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        let okAction = UIAlertAction(title: "確定", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            
            self.services.deleteItem(cartItemId: self.item.id)
                .subscribe(onNext:{ [unowned self] bool in
                    if bool == true {
                        self.delegate?.deleteSection!(section: self.section)
                    }
                })
                .disposed(by: self.rx.disposeBag)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        delegate?.showAlert!(alertController: alertController)
    }
}

private extension CartExpandView {
    func initUI() {
        deleteButton.setAttributedTitle(NSAttributedString(string: "刪除", attributes: [.font: UIFont.systemFont(ofSize: 16),.foregroundColor: pinkButtonBg!]), for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteSection(_:)), for: .touchUpInside)
        
        plusButton.backgroundColor = .white
        plusButton.setup(title: "+", textColor: .black)
        plusButton.makeCircle()
        plusButton.makeBorder(width: 1.0)
        plusButton.addTarget(self, action: #selector(plusAction(_:)), for: .touchUpInside)
        
        countLabel.textAlignment = .center
        countLabel.textColor = .black
        countLabel.makeBorder(width: 1.0)
        
        minusButton.setup(title: "-", textColor: .black)
        minusButton.makeCircle()
        minusButton.makeBorder(width: 1.0)
        minusButton.backgroundColor = .white
        minusButton.addTarget(self, action: #selector(minusAction(_:)), for: .touchUpInside)
        
        addSubViews(views: deleteButton, plusButton, countLabel, minusButton)
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

