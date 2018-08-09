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
    let productTypeNameLabel = UILabel()
    let productNameLabel = UILabel()
    let countLabel = UILabel()
    
    var cartItem: DeliveryInfoCartItem? {
        didSet {
            updateUI()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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

private extension InfoProductCell {
    func initUI() {
        
        selectionStyle = .none
        
        productImageView.contentMode = .scaleAspectFill
        productImageView.makeShadow(shadowOpacity: 0.3, shadowOffsetW: 0.3, shadowOffsetH: 0.4)
        
        productTypeNameLabel.setup(textAlignment: .left, fontSize: 20, textColor: grayColor)
        productNameLabel.setup(textAlignment: .left, fontSize: 16, textColor: grayColor)
        
        countLabel.setup(textAlignment: .right, fontSize: 20, textColor: grayColor)
        
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

        guard let item = cartItem?.cartItem else { return }
        let giftboxId = item.getProduct().getGiftboxTypeId()
        let url = URL(string: String(giftboxId).giftBoxUrl())
        let productName = item.getProduct().getName()
        let productTypeName = item.getProduct().getProductTypeName()
        let count = cartItem?.count
        
        productImageView.kf.setImage(with: url)
        productTypeNameLabel.text = productTypeName
        productNameLabel.text = productName
        
        countLabel.text = "X \(count ?? 0)"
    }
}
