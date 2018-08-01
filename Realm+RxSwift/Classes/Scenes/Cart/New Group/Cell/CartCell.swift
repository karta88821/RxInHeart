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
    let foodNameLabel = UILabel()
    let countLabel = UILabel()
    
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
        addConstraint()
    }
    
    func isShow() {
        if let expaned = expaned {
            self.isHidden = !expaned
        }
    }
    
    func updateUI() {
        guard let item = self.item ,
              let foodId = item.foodId ,
              let foodName = item.food.name ,
              let count = item.count else { return }
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
        foodNameLabel.setup(textAlignment: .left, fontSize: 18, textColor: grayColor)
        countLabel.setup(textAlignment: .right, fontSize: 18, textColor: grayColor)
        
        contentView.addSubview(containerView)
        containerView.addSubViews(views: foodImageView, foodNameLabel, countLabel)
    }
    
    func setupUI(foodId:Int, foodName: String, count: Int) {
        let string = String(foodId).foodUrl()
        let url = URL(string: string)
        foodImageView.kf.setImage(with: url)
        foodNameLabel.text = foodName
        
        countLabel.text = "\(count)個"
    }
    
    func addConstraint() {
        
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
        containerView.removeFromSuperview()
        
        foodImageView.contentMode = .scaleAspectFill
        
        contentView.addSubViews(views: foodImageView, foodNameLabel, countLabel)
        contentView.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        constraintUI()
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



