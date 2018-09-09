//
//  InfoProductCell.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/10.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import Reusable

class InfoProductCell: UITableViewCell, Reusable {
    
    // MARK : - UI
    let productImageView = UIImageView()
    let productTypeNameLabel = UILabel(alignment: .left, fontSize: 20)
    let productNameLabel = UILabel(alignment: .left, fontSize: 16)
    let countLabel = UILabel(alignment: .left, fontSize: 16)
    
    var cartItem: DeliveryInfoCartItem? {
        didSet {
            updateUI()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
        constraintUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initUI()
        constraintUI()
    }
}

private extension InfoProductCell {
    func initUI() {
        selectionStyle = .none
        
        productImageView.contentMode = .scaleAspectFill
        productImageView.makeShadow(shadowOpacity: 0.3, shadowOffsetW: 0.3, shadowOffsetH: 0.4)
        
        contentView.addSubViews(views: productImageView, productTypeNameLabel, productNameLabel, countLabel)
    }
    
    func constraintUI() {
        
        productImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20)
            $0.left.equalToSuperview().offset(40)
            $0.width.equalTo(100)
        }
        
        productTypeNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(10)
            $0.left.equalTo(productImageView.snp.right).offset(40)
        }
        
        productNameLabel.snp.makeConstraints {
            $0.bottom.equalTo(productTypeNameLabel.snp.top)
            $0.left.equalTo(productTypeNameLabel.snp.left)
        }
        
        countLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-25)
        }
    }
    
    func updateUI() {

        guard let product = cartItem?.cartItem.product,
              let count = cartItem?.count else { return }

        let giftboxId = product.giftboxTypeId
        let productName = product.name
        let productTypeName = product.productTypeName
        let url = URL(string: String(giftboxId).giftBoxUrl())
        
        productImageView.kf.setImage(with: url)
        productTypeNameLabel.text = productTypeName
        productNameLabel.text = productName
        
        countLabel.text = "X \(count)"
    }
}
