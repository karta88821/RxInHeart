//
//  PaymentInfoCell.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/25.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import SnapKit

class PaymentInfoCell: InfoCell {
    
    let topView = UIView()
    let bottomView = UIView()
    let bottomStackView = UIStackView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupPayment()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupPayment()
    }
    
    func setupPayment() {
        stackView.removeFromSuperview()
        topView.backgroundColor = .white
        bottomView.backgroundColor = .white
        contentView.backgroundColor = .lightGray
        
        bottomStackView.axis = .vertical
        bottomStackView.spacing = 5
        bottomStackView.distribution = .equalSpacing
        
        contentView.addSubViews(views: topView, bottomView)
        topView.addSubview(stackView)
        bottomView.addSubViews(views: bottomStackView)
    }
    
    override func layoutSubviews() {
        topView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(90)
        }

        bottomView.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.top.equalTo(topView.snp.bottom).offset(1)
        }
        
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.left.right.equalToSuperview().inset(20)
        }
        
        bottomStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.left.right.equalToSuperview().inset(20)
        }
    }
    
    func setupUI(with paymentInfo: PaymentInfo, and totalCount: Int) {
        
        stackView.removeAllArrangedSubviews()
        bottomStackView.removeAllArrangedSubviews()
        
        let paymentInfoList = [("付款人", paymentInfo.name),
                               ("聯絡電話", paymentInfo.phoneNumber),
                               ("信箱", paymentInfo.email)]
        
        
        for (key, value) in paymentInfoList {
            let titleLabel = UILabel(alignment: .left, text: key)
            let infoLabel = UILabel(alignment: .right, text: value)
            
            let horizontalStackView = UIStackView(arrangedSubviews: [titleLabel, infoLabel])
            horizontalStackView.axis = .horizontal
            
            stackView.addArrangedSubview(horizontalStackView)
        }
        
        let priceInfoList = [("訂單金額", "$ \(totalCount)"),
                             ("運費", "0")]
        
        for (key, value) in priceInfoList {
            let titleLabel = UILabel(alignment: .left, text: key)
            let infoLabel = UILabel(alignment: .right, text: value)
            
            let horizontalStackView = UIStackView(arrangedSubviews: [titleLabel, infoLabel])
            horizontalStackView.axis = .horizontal
            
            bottomStackView.addArrangedSubview(horizontalStackView)
        }
        
    }
}
