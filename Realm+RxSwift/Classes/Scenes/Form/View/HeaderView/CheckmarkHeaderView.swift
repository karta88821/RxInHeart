//
//  CheckmarkHeaderView.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/18.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import SnapKit
import M13Checkbox
import Reusable

class CheckmarkHeaderView: UITableViewHeaderFooterView, Reusable {
    
    let checkBox = M13Checkbox()
    let titleLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
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
    
    func setupTitle(with title: String) {
        titleLabel.text = title
    }
}

private extension CheckmarkHeaderView {
    
    func initUI() {
        contentView.backgroundColor = .white
        contentView.makeShadow(shadowOpacity: 0.1, shadowOffsetW: 0.1, shadowOffsetH: 0.1)
        
        checkBox.tintColor = darkRed!
        checkBox.checkmarkLineWidth = 5
        checkBox.stateChangeAnimation = .expand(.fill)
        checkBox.boxType = .square
        titleLabel.setup(textAlignment: .left, fontSize: 18, textColor: grayColor)
        
        contentView.addSubViews(views: checkBox, titleLabel)
    }
    
    func constraintUI() {
        checkBox.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12).priority(900)
            $0.left.equalToSuperview().offset(20)
            $0.width.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(checkBox.snp.right)
        }
    }
}
