//
//  BaseHeader.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/2.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import SnapKit
import DropDown
import Reusable

enum BaseTitle: String {
    case delivery = "運送方式"
    case payment = "付款方式"
    
    func getString() -> String {
        switch self {
        case .delivery:
            return BaseTitle.delivery.rawValue
        case .payment:
            return BaseTitle.payment.rawValue
        }
    }
}

class BaseHeader: UITableViewHeaderFooterView, Reusable {

    let titleLabel = UILabel(alignment: .left, fontSize: 20)
    let dropButton = UIButton()
    let dropDown = DropDown()
    
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

private extension BaseHeader {
    func initUI() {
        
        contentView.backgroundColor = .white
        contentView.makeShadow(shadowOpacity: 0.1, shadowOffsetW: 0.1, shadowOffsetH: 0.1)
        
        dropButton.backgroundColor = dropBg
        dropButton.makeShadow(shadowOpacity: 0.1, shadowOffsetW: 0.1, shadowOffsetH: 0.1)
        dropButton.addTarget(self, action: #selector(showDropList(_:)), for: .touchUpInside)
        
        dropDown.anchorView = dropButton
        
        dropDown.bottomOffset = CGPoint(x: 0, y: dropButton.bounds.height)
        dropDown.backgroundColor = .white
        dropDown.selectionBackgroundColor = selectionBg!
        
        contentView.addSubViews(views: titleLabel, dropButton)
    }
    
    func constraintUI() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
        dropButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20).priority(900)
            $0.left.equalTo(titleLabel.snp.right).offset(30)
            $0.width.equalTo(150)
        }
    }
    
    @objc func showDropList(_ sender: AnyObject) {
        dropDown.show()
    }
}
