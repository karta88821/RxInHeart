//
//  OrderInfoCell.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/27.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import SnapKit

class OrderInfoCell: InfoCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupUI(with orderInfo: OrderInfo) {
        
        stackView.removeAllArrangedSubviews()
        
        let orderInfoList = [("運送方式", orderInfo.deliveryType.getString()),
                             ("付款方式", orderInfo.paymentType.getString()),
                             ("付款狀態", orderInfo.payStatus.rawValue),
                             ("負責業務", orderInfo.businessInfo.name)]
        
        
        for (key, value) in orderInfoList {
            let titleLabel = UILabel(alignment: .left, text: key)
            let infoLabel = UILabel(alignment: .right, text: value)
            
            if key == "付款狀態" {
                infoLabel.textColor = orderInfo.payStatus.textColor()
            }
            
            let horizontalStackView = UIStackView(arrangedSubviews: [titleLabel, infoLabel])
            horizontalStackView.axis = .horizontal
            
            stackView.addArrangedSubview(horizontalStackView)
        }
    }
    
}
