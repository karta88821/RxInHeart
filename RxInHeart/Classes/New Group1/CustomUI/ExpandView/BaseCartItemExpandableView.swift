//
//  BaseCartItemExpandableView.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/8/14.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import SnapKit

class BaseCartItemExpandableView: BaseExpandableView {
    var item: CartItem!
    
    let containerView = UIView()
    let giftboxImageView = UIImageView()
    let productNameLabel = UILabel(alignment: .left, fontSize: 22)
    let nameLabel = UILabel(alignment: .left, fontSize: 18)
    let priceLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initUI()
        addConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initUI()
        addConstraint()
    }
    
    func setupUI(cartItem: CartItem, section: Int, delegate: BaseExpandable) {
        guard let product = cartItem.product else { return }
        self.item = cartItem
        self.congifureImageView(giftboxTypeId: product.giftboxTypeId)
        self.productNameLabel.text = product.productTypeName
        self.nameLabel.text = product.name
        self.configurePriceLabel(price: product.price)
        self.section = section
        self.delegate = delegate
    }
}

private extension BaseCartItemExpandableView {
    
    func initUI() {
        containerView.backgroundColor = .white
        
        giftboxImageView.makeShadow(shadowOpacity: 0.3, shadowOffsetH: 0.3)
        giftboxImageView.contentMode = .scaleAspectFill
        
        addSubview(containerView)
        containerView.addSubViews(views: giftboxImageView, productNameLabel, nameLabel, priceLabel)
        
        containerView.makeShadow(cornerRadius: 20, shadowOpacity: 0.3, shadowOffsetW: 0.2, shadowOffsetH: 0.2)
    }
    
    func addConstraint() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        
        giftboxImageView.snp.makeConstraints { make in
            make.width.equalTo(175)
            make.top.left.bottom.equalToSuperview().inset(20)
        }
        
        productNameLabel.snp.makeConstraints { make in
            make.left.equalTo(giftboxImageView.snp.right).offset(20)
            make.centerY.equalToSuperview().offset(-50)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(productNameLabel.snp.left)
            make.centerY.equalTo(productNameLabel.snp.bottom).offset(15)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.left.equalTo(productNameLabel.snp.left)
            make.centerY.equalTo(nameLabel.snp.bottom).offset(30)
        }
    }
    
    func congifureImageView(giftboxTypeId: Int?) {
        if giftboxTypeId != nil {
            let url = URL(string: String(describing: giftboxTypeId!).giftBoxUrl())
            self.giftboxImageView.kf.setImage(with: url)
        } else {
            self.giftboxImageView.backgroundColor = grayColor
        }
    }
    
    func configurePriceLabel(price: Int) {
        let amountText = NSMutableAttributedString(string: "單價 $\(price)")
        
        amountText.setAttributes([.font: UIFont.systemFont(ofSize: 16)],
                                 range: NSRange(location: 0, length: 2))
        
        priceLabel.attributedText = amountText
        priceLabel.textColor = grayColor
    }
}
