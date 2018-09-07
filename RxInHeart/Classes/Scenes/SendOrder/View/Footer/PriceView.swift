//
//  PriceView.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/23.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import SnapKit

class PriceView: UIView {
    
    let topView = UIView()
    let bottomView = UIView()
    let sepView = UIView()
    var titleLabel: UILabel!
    var priceLabel: UILabel!
    
    enum SectionType {
        case cartItem
        case payment
        case delivery
    }
    
    var type: SectionType = .cartItem {
        didSet {
            updateUI()
            constraintUI()
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
    
    func setupPriceText(with price: Int) {
        priceLabel.text = "$\(price)"
    }
    
}

private extension PriceView {
    func initUI() {
        backgroundColor = pinkBackground
        topView.backgroundColor = .white
        bottomView.backgroundColor = pinkBackground
        sepView.backgroundColor = sepBackground
        addSubViews(views: topView, bottomView)
        topView.addSubViews(views: sepView)
        //topView.makeShadow(shadowOpacity: 0.1, shadowOffsetW: 0.1, shadowOffsetH: 0)
    }
    
    func constraintUI() {
        
        topView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        bottomView.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.top.equalTo(topView.snp.bottom).offset(1)
        }
        
        sepView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
        priceLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            switch type {
            case .cartItem:
                $0.right.equalToSuperview().inset(30)
            case .payment, .delivery:
                $0.right.equalToSuperview().inset(15)
            }
        }
    }
    
    func updateUI() {
        switch type {
        case .cartItem:
            configurePriceUI(with: "訂單金額", and: 18)
        case .payment:
            configurePriceUI(with: "運費", and: 16)
        case .delivery:
            configurePriceUI(with: "付款金額", and: 16)
        }
    }
    
    func configurePriceUI(with titleText: String?, and fontSize: CGFloat) {
        self.titleLabel = UILabel(alignment: .left, fontSize: fontSize, text: titleText)
        self.priceLabel = UILabel(alignment: .right, fontSize: fontSize)
        topView.addSubViews(views: titleLabel, priceLabel)
    }
}
