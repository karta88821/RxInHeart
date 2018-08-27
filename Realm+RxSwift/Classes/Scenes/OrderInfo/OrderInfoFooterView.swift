//
//  OrderInfoFooterView.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/27.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import SnapKit

class OrderInfoFooterView: UIView {
    
    let paymentButton = UIButton()
    let popButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        constraintUI()
    }
    
    func initUI() {
        paymentButton.makeShadow(cornerRadius: 20, shadowOpacity: 0.2, shadowOffsetH: 0.3)
        paymentButton.clipsToBounds = true
        paymentButton.backgroundColor = pinkButtonBg
        paymentButton.setup(title: "立即付款", textColor: .white)
        paymentButton.addTarget(self, action: #selector(paymentBtnDimAnimation(_:)), for: .touchUpInside)
        
        popButton.makeShadow(cornerRadius: 20, shadowOpacity: 0.2, shadowOffsetH: 0.3)
        popButton.clipsToBounds = true
        popButton.makeBorder(width: 2, color: pinkButtonBg!)
        popButton.backgroundColor = .white
        popButton.setup(title: "取消訂單", textColor: pinkButtonBg)

        backgroundColor = pinkBackground
        addSubViews(views: paymentButton, popButton)
    }
    
    @objc func paymentBtnDimAnimation(_ sender: UIButton) {
        paymentButton.dim()
    }
    
    func constraintUI() {
        paymentButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(25).priority(900)
            $0.width.equalTo(150)
            $0.left.equalToSuperview().offset(45)
        }
        popButton.snp.makeConstraints {
            $0.top.equalTo(paymentButton.snp.top)
            $0.bottom.equalTo(paymentButton.snp.bottom)
            $0.width.equalTo(150)
            $0.right.equalToSuperview().offset(-45)
        }
    }
}
