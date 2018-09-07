//
//  InfoDeliveryCell.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/9.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import Reusable

class InfoDeliveryCell: UITableViewCell, Reusable {

    let label = UILabel(alignment: .left, fontSize: 14, textColor: pinkButtonBg)
    let infoLabel = UILabel(alignment: .left, fontSize: 18)
    
    var title: String? {
        didSet {
            updateTitle()
        }
    }
    
    var infoText: String? {
        didSet {
            updateText()
        }
    }
    
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

private extension InfoDeliveryCell {
    
    func initUI() {
        selectionStyle = .none
        contentView.addSubViews(views: label, infoLabel)
    }
    
    func constraintUI() {
        infoLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(15)
            $0.left.equalToSuperview().offset(20)
        }
        label.snp.makeConstraints {
            $0.bottom.equalTo(infoLabel.snp.top)
            $0.left.equalToSuperview().offset(20)
        }
    }
    
    func updateTitle() {
        if let title = title {
            label.text = title
        }
    }
    
    func updateText() {
        if let infoText = infoText {
            infoLabel.text = infoText
        }
    }

}
