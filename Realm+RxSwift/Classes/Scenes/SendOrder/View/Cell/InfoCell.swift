//
//  InfoCell.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/25.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import SnapKit
import Reusable

class InfoCell: UITableViewCell, Reusable {
    
    let stackView = UIStackView()
    
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

private extension InfoCell {
    func initUI() {
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .equalSpacing
        contentView.backgroundColor = .white
        contentView.addSubview(stackView)
        selectionStyle = .none
    }
    func constraintUI() {
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.left.right.equalToSuperview().inset(20)
        }
    }
}
