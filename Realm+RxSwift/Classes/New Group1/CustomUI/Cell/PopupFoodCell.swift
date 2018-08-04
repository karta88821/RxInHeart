//
//  PopupFoodCell.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/8/2.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import SnapKit

class PopupFoodCell: CartCell {
    
    enum CellType {
        case allocatePopup
        case orderPopup
    }
    
    var cellType: CellType? = .allocatePopup {
        didSet {
            constraintUI()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
        constraintUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initUI()
        constraintUI()
    }
    
    private func initUI() {
        containerView.removeFromSuperview()
        
        foodImageView.contentMode = .scaleAspectFill
        
        contentView.addSubViews(views: foodImageView, foodNameLabel, countLabel)
        contentView.backgroundColor = .white
    }
    
    private func constraintUI() {
        guard let cellType = cellType else { return }
        
        foodImageView.snp.makeConstraints{ make in
            make.top.bottom.equalToSuperview().inset(10).priority(900)
            switch cellType {
            case .allocatePopup:
                make.left.equalToSuperview().offset(30)
            case .orderPopup:
                make.left.equalToSuperview().offset(20)
            }
            make.width.equalTo(45)
        }
        
        foodNameLabel.snp.makeConstraints{ make in
            make.centerY.equalToSuperview()
            make.left.equalTo(foodImageView.snp.right).offset(15)
        }
        
        countLabel.snp.makeConstraints{ make in
            make.centerY.equalToSuperview()
            switch cellType {
            case .allocatePopup:
                make.right.equalToSuperview().inset(30)
            case .orderPopup:
                make.right.equalToSuperview().inset(20)
            }
        }
    }
}
