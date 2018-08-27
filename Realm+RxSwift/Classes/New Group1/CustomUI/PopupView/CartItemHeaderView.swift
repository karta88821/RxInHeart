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

    let giftBoxLabel = UILabel(alignment: .left, fontSize: 18)
    let countLabel = UILabel(alignment: .right, fontSize: 18)
    
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
        guard let deliveryInfoCartItem = deliveryInfoCartItem,
              let giftboxTypeName = deliveryInfoCartItem.cartItem.product.giftboxTypeName,
              let productTypeName = deliveryInfoCartItem.cartItem.product.productTypeName else { return }

        giftBoxLabel.text = "\(giftboxTypeName) / \(productTypeName)"
        countLabel.text = "\(deliveryInfoCartItem.count)盒"
    }
}
