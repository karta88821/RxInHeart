//
//  InfoHeaderView.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/9.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import SnapKit

class InfoHeaderView: UITableViewHeaderFooterView {
    
    // MARK : - UI
    let titleLabel = UILabel(alignment: .left, fontSize: 15)
    let editButton = UIButton()
    
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
}

private extension InfoHeaderView {
    
    func initUI() {
        contentView.backgroundColor = .white
        contentView.makeShadow(shadowOpacity: 0.1, shadowOffsetW: 0.1, shadowOffsetH: 0.1)
        let attributeString = NSAttributedString(
            string: "編輯",
            attributes: [.font: UIFont.systemFont(ofSize: 15),
                         .foregroundColor: darkRed!]
        )
        editButton.setAttributedTitle(attributeString, for: .normal)
        contentView.addSubViews(views: titleLabel, editButton)
    }
    
    func constraintUI() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
        editButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
        }
    }

}
