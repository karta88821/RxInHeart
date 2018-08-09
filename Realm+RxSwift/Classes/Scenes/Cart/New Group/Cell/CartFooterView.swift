//
//  CartFooterView.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/17.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import SnapKit

class CartFooterView: UIView {
    
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.makeShadow(shadowOpacity: 0.3, shadowOffsetW: 0.2, shadowOffsetH: 0.2)
        return view
    }()
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = pinkBackground
        return view
    }()
    lazy var label: UILabel = {
        let lb = UILabel()
        lb.setupWithTitle(textAlignment: .left, fontSize: 18, text: "訂單金額")
        return lb
    }()
    lazy var subtotalLabel: UILabel = {
        let label = UILabel()
        label.setup(textAlignment: .left, fontSize: 18)
        return label
    }()
    lazy var checkoutButton: UIButton = {
        let button = UIButton()
        button.makeShadow(cornerRadius: 20, shadowOpacity: 0.2, shadowOffsetH: 0.3)
        button.clipsToBounds = true
        button.backgroundColor = pinkButtonBg
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        constraintsUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        
        addSubViews(views: topView, bottomView)
        topView.addSubViews(views: label, subtotalLabel)
        bottomView.addSubViews(views: checkoutButton)
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
