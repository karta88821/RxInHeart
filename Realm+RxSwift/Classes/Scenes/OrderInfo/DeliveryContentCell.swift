//
//  DeliveryContentCell.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/28.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit

class DeliveryContentCell: InfoCell {
    
    let bottomView = UIView()
    let contentTitleLabel = UILabel()
    let contentButton = UIButton()
    
    var deliveryInfo: DeliveryInfo?
    var delegate: PopViewPresentable?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initUI()
    }
    
    override func layoutSubviews() {
        constraintUI()
    }
    
    func setupUI(with deliveryInfo: DeliveryInfo) {
        
        self.deliveryInfo = deliveryInfo
        
        stackView.removeAllArrangedSubviews()
        
        let deliveryInfoList = [("收貨人", deliveryInfo.name),
                                ("聯絡電話", deliveryInfo.phone),
                                ("宅配地址", deliveryInfo.address)]
        
        for (key, value) in deliveryInfoList {
            let titleLabel = UILabel()
            let infoLabel = UILabel()
            titleLabel.setupWithTitle(textAlignment: .left, fontSize: 16, textColor: grayColor, text: key)
            infoLabel.setupWithTitle(textAlignment: .right, fontSize: 16, textColor: grayColor, text: value)
            
            let horizontalStackView = UIStackView(arrangedSubviews: [titleLabel, infoLabel])
            horizontalStackView.axis = .horizontal
            
            stackView.addArrangedSubview(horizontalStackView)
        }
    }
    
    @objc func popAction(_ sender: AnyObject) {
        guard let deliveryInfo = deliveryInfo else { return }
        delegate?.showPopup(item: nil, deliveryInfo: deliveryInfo)
    }
}

private extension DeliveryContentCell {
    
    func initUI() {
        bottomView.backgroundColor = .white
        contentView.addSubview(bottomView)
        
        contentTitleLabel.setupWithTitle(textAlignment: .left, fontSize: 16, textColor: grayColor, text: "宅配內容")
        let attributeString = NSAttributedString(string: "內容",
                                                 attributes: [.font: UIFont.systemFont(ofSize: 16),
                                                              .foregroundColor: textFieldTitleColor!])
        contentButton.setAttributedTitle(attributeString, for: .normal)
        contentButton.addTarget(self, action: #selector(popAction(_:)), for: .touchUpInside)
        
        bottomView.addSubViews(views: contentTitleLabel, contentButton)
    }
    
    func constraintUI() {
        bottomView.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalTo(bottomView.snp.top).offset(-5)
        }
        
        contentTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
        contentButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(20)
        }
    }
}
