//
//  CartFooterView.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/17.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import Then
import SnapKit

class CartFooterView: UIView {
    
    let topView = UIView()
    let bottomView = UIView()
    
    let label = UILabel()
    let subtotalLabel = UILabel()
    
    let checkoutButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initUI()
        constraintsUI()
    }
    
    func setupUI(buttonTitle: String) {
        checkoutButton.setup(title: buttonTitle, textColor: .white)
    }

}

private extension CartFooterView {
    func initUI() {
        backgroundColor = pinkBackground
        topView.backgroundColor = .white
        bottomView.backgroundColor = pinkBackground
        label.setupWithTitle(textAlignment: .left, fontSize: 18, text: "訂單金額")
        subtotalLabel.setup(textAlignment: .left, fontSize: 18)
        checkoutButton.makeShadow(cornerRadius: 20, shadowOpacity: 0.2, shadowOffsetH: 0.3)
        checkoutButton.clipsToBounds = true
        checkoutButton.backgroundColor = pinkButtonBg!
        
        addSubViews(views: topView, bottomView)
        topView.addSubViews(views: label, subtotalLabel)
        bottomView.addSubViews(views: checkoutButton)
        
        topView.makeShadow(shadowOpacity: 0.3, shadowOffsetW: 0.2, shadowOffsetH: 0.2)
    }
    
    func constraintsUI() {
        topView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        bottomView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(2)
            $0.left.bottom.right.equalToSuperview()
        }
        
        label.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
        subtotalLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(20)
        }
        
        checkoutButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(180)
            $0.height.equalTo(40)
        }
    }
}
