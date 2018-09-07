//
//  SendOrderExpandableView.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/8/14.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit

class SendOrderExpandView: BaseCartItemExpandableView {
    
    let countLabel = UILabel(alignment: .left, fontSize: 18)
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        containerView.removeFromSuperview()
        
        contentView.backgroundColor = .white
        //makeShadow(shadowOpacity: 0.1, shadowOffsetW: 0.1, shadowOffsetH: 0.1)
        addSubViews(views: giftboxImageView, productNameLabel, nameLabel, priceLabel, countLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        giftboxImageView.snp.makeConstraints { make in
            make.width.equalTo(175)
            make.top.bottom.equalToSuperview().inset(20)
            make.left.equalToSuperview().offset(30)
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
        
        countLabel.snp.makeConstraints {
            $0.left.equalTo(priceLabel.snp.right).offset(20)
            $0.bottom.equalTo(priceLabel.snp.bottom)
        }
    }
    
    func setupCountText(with count: Int) {
        let countText = NSMutableAttributedString(string: "X \(count) 個")
        countText.setAttributes([.font: UIFont.systemFont(ofSize: 14)],
                                range: NSRange(location: 4, length: 1))
        countLabel.attributedText = countText
    }
    
}

