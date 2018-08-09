//
//  CartItemHeaderView.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/28.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import SnapKit

class CartItemHeaderView: UIView {
    
    let giftBoxLabel = UILabel()
    let countLabel = UILabel()
    
    var deliveryInfoCartItem: DeliveryInfoCartItem? {
        didSet {
            updateUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        constraintUI()
    }
}

private extension CartItemHeaderView {
    
    func initUI() {
        backgroundColor = .white
        giftBoxLabel.setup(textAlignment: .left, fontSize: 18, textColor: grayColor)
        countLabel.setup(textAlignment: .right, fontSize: 18, textColor: grayColor)
        addSubViews(views: giftBoxLabel, countLabel)
    }
    
    func constraintUI() {
        giftBoxLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
        }
        
        countLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(15)
        }
    }
    
    func updateUI() {
        guard let deliveryInfoCartItem = deliveryInfoCartItem else { return }
        
        let giftboxTypeName = deliveryInfoCartItem.cartItem.getProduct().getGiftboxTypeName()
        let productTypeName = deliveryInfoCartItem.cartItem.getProduct().getProductTypeName()
        
        giftBoxLabel.text = "\(giftboxTypeName) / \(productTypeName)"
        countLabel.text = "\(deliveryInfoCartItem.count)盒"
    }
}
