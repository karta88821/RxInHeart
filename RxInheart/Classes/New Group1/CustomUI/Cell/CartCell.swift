//
//  CartCell.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/16.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import Reusable

class CartCell: UITableViewCell, Reusable {
    
    var expaned: Bool? {
        didSet {
            isShow()
        }
    }
    
    var item: PickedItem_cart? {
        didSet {
            updateUI()
        }
    }
    
    let containerView = UIView()
    let foodImageView = UIImageView()
    let foodNameLabel = UILabel(alignment: .left, fontSize: 18)
    let countLabel = UILabel(alignment: .right, fontSize: 18)
    
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
    
    func isShow() {
        if let expaned = expaned {
            self.isHidden = !expaned
        }
    }
    
    func updateUI() {
        guard let item = item,
              let foodId = item.foodId,
              let foodName = item.food.name,
              let count = item.count  else { return }
        
        let string = String(foodId).foodUrl()
        let url = URL(string: string)
        foodImageView.kf.setImage(with: url)
        foodNameLabel.text = foodName
        
        countLabel.text = "\(count)個"
    }
}

private extension CartCell {
    
    func initUI() {
        selectionStyle = .none
        contentView.backgroundColor = pinkBackground
        containerView.backgroundColor = .white
        
        foodImageView.contentMode = .scaleAspectFill
        
        contentView.addSubview(containerView)
        containerView.addSubViews(views: foodImageView, foodNameLabel, countLabel)
    }
    
    func constraintUI() {
        containerView.snp.makeConstraints{ make in
            make.top.bottom.equalToSuperview().priority(900)
            make.left.right.equalToSuperview().inset(10).priority(900)
        }
        
        foodImageView.snp.makeConstraints{ make in
            make.top.bottom.equalToSuperview().inset(10).priority(900)
            make.left.equalToSuperview().inset(30)
            make.width.equalTo(45)
        }
        
        foodNameLabel.snp.makeConstraints{ make in
            make.centerY.equalToSuperview()
            make.left.equalTo(foodImageView.snp.right).offset(15)
        }
        
        countLabel.snp.makeConstraints{ make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-30)
        }
    }
}
