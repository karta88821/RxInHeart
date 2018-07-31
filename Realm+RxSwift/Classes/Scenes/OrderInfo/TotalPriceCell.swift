//
//  TotalPriceCell.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/27.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import SnapKit

class TotalPriceCell: InfoCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupUI(with price: Int, and freight: Int) {
        
        stackView.removeAllArrangedSubviews()

        let totalPriceList = [("訂單金額", "$ \(price)"),
                              ("運費", "\(freight)"),
                              ("付款金額", "$ \(price + freight)") ]
        
        
        for (key, value) in totalPriceList {
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

