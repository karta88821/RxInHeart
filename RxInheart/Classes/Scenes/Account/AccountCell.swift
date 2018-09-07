//
//  AccountCell.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/13.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import Reusable

class AccountCell: UITableViewCell, Reusable {
    
    var title: String? {
        didSet {
            updateUI()
        }
    }
    
    let titleLabel = UILabel(alignment: .left, fontSize: 18)
    let arrowLabel = UILabel()
    
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
    
    private func updateUI() {
        titleLabel.text = title
    }
}

private extension AccountCell {
    func initUI() {

        arrowLabel.text = ">"
        arrowLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        arrowLabel.textAlignment = .right
        arrowLabel.textColor = .black
        
        contentView.addSubViews(views: titleLabel, arrowLabel)
        contentView.backgroundColor = .white
        contentView.makeShadow(shadowOpacity: 0.2, shadowOffsetW: 0.1, shadowOffsetH: 0.1)
    }
    
    func constraintUI() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(30)
        }
        
        arrowLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.right.equalToSuperview().offset(-20)
        }
    }
}
