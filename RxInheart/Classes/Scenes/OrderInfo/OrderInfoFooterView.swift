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
    
    // MARK : - UI
    var paymentButton: UIButton!
    var popButton: UIButton!
    
    // MARK : - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        constraintUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func paymentBtnDimAnimation(_ sender: UIButton) {
        paymentButton.dim()
    }
    
}

private extension OrderInfoFooterView {
    func createViews() {
        configurePaymentButton()
        confiurePopButton()
    }
    
    func configureView() {
        createViews()
        addSubViews(views: paymentButton, popButton)
        backgroundColor = pinkBackground
    }
    
    func configurePaymentButton() {
        paymentButton = {
            let button = UIButton()
            button.makeShadow(cornerRadius: 20, shadowOpacity: 0.2, shadowOffsetH: 0.3)
            button.clipsToBounds = true
            button.backgroundColor = pinkButtonBg
            button.setup(title: "立即付款", textColor: .white)
            button.addTarget(self, action: #selector(paymentBtnDimAnimation(_:)), for: .touchUpInside)
            
            return button
        }()
    }
    
    func confiurePopButton() {
        popButton = {
            let button = UIButton()
            button.makeShadow(cornerRadius: 20, shadowOpacity: 0.2, shadowOffsetH: 0.3)
            button.clipsToBounds = true
            button.makeBorder(width: 2, color: pinkButtonBg!)
            button.backgroundColor = .white
            button.setup(title: "取消訂單", textColor: pinkButtonBg)
            
            return button
        }()
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
