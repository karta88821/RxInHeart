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
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "刪除",
                                                     attributes: [.font: UIFont.systemFont(ofSize: 16),
                                                                  .foregroundColor: pinkButtonBg!]), for: .normal)
        button.addTarget(self, action: #selector(deleteSection(_:)), for: .touchUpInside)
        return button
    }()
    lazy var plusButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setup(title: "+", textColor: .black)
        button.makeBorder(width: 1.0)
        button.addTarget(self, action: #selector(plusAction(_:)), for: .touchUpInside)
        return button
    }()
    lazy var countLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.makeBorder(width: 1.0)
        return label
    }()
    lazy var minusButton: UIButton = {
        let button = UIButton()
        button.setup(title: "-", textColor: .black)
        button.makeBorder(width: 1.0)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(minusAction(_:)), for: .touchUpInside)
        return button
    }()
    
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

        self.countLabel.text = String(item.getCount())
        
    }
}

extension CartExpandView {
    @objc func plusAction(_ sender: UIButton) {
        services.updateItem(cartItemId: item.getId(), item: addItem())
            .subscribe(onNext:{ [unowned self] bool in
                if bool == true {
                    self.delegate?.reloadData!()
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
    @objc func minusAction(_ sender: UIButton) {
        if item.getCount() > 1 {
            services.updateItem(cartItemId: item.getId(), item: minusItem())
                .subscribe(onNext:{ [unowned self] bool in
                    if bool == true {
                        self.delegate?.reloadData!()
                    }
                })
                .disposed(by: rx.disposeBag)
        }

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
            
            self.services.deleteItem(cartItemId: self.item.getId())
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
        addSubViews(views: deleteButton, plusButton, countLabel, minusButton)
        plusButton.makeCircle()
        minusButton.makeCircle()
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
        
        let addCount = item.getCount() + 1
        let addSubtotal = addCount * item.getProduct().getPrice()
        return CartItem(id: item.getId(), count: addCount, subtotal: addSubtotal, pickedItem: item.getPickItems(), productId: item.getProductId(), cartId: item.getCartId())
    }
    
    func minusItem() -> CartItem {
        
        let minusCount = item.getCount() - 1
        let minusSubtotal = minusCount * item.getProduct().getPrice()
        return CartItem(id: item.getId(), count: minusCount, subtotal: minusSubtotal, pickedItem: item.getPickItems(), productId: item.getProductId(), cartId: item.getCartId())
    }
}

