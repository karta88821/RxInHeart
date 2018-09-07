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

    // MARK : - UI
    var giftBoxLabel: UILabel!
    var countLabel: UILabel!
    
    // MARK : - Property
    var deliveryInfoCartItem: DeliveryInfoCartItem? {
        didSet {
            updateUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createViews()
        configureView()
        constraintUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createViews()
        configureView()
        constraintUI()
    }
}

private extension CartItemHeaderView {
    
    func configureGiftBoxLabel() {
        giftBoxLabel = UILabel(alignment: .left, fontSize: 18)
    }
    
    func configureCountLabel() {
        countLabel = UILabel(alignment: .right, fontSize: 18)
    }
    
    func createViews() {
        configureGiftBoxLabel()
        configureCountLabel()
    }
    
    func configureView() {
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
