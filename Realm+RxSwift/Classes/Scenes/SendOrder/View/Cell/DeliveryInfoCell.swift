//
//  DeliveryInfoCell.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/25.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit

class DeliveryInfoCell: InfoCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupUI(with deliveryInfo: DeliveryInfo) {
        
        stackView.removeAllArrangedSubviews()
        
        let totalCount = deliveryInfo.deliveryInfoCartItems.map{$0.count}.reduce(0,{$0 + $1})
        let deliveryInfoList = [("收貨人", deliveryInfo.name),
                                ("宅配數量", "\(totalCount) 箱"),
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

}
