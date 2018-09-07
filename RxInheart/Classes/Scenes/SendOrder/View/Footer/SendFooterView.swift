//
//  SendFooterView.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/25.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import SnapKit

class SendFooterView: UIView {
    let button = UIButton()
    
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
        button.makeShadow(cornerRadius: 20, shadowOpacity: 0.2, shadowOffsetH: 0.3)
        button.clipsToBounds = true
        button.backgroundColor = pinkButtonBg
        button.setup(title: "送出訂單", textColor: .white)
        backgroundColor = pinkBackground
        addSubview(button)
    }
    
    func constraintUI() {
        button.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(25).priority(900)
            $0.left.right.equalToSuperview().inset(120)
        }
    }
}
