//
//  BaseExpandView.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/30.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import SnapKit
import Then
import Kingfisher

@objc protocol BaseExpandable {
    func toggleSection(header: BaseExpandView, section: Int)
    @objc optional func reloadData()
    @objc optional func deleteSection(section: Int)
    @objc optional func showAlert(alertController: UIAlertController) 
}

//extension BaseExpandable {
//    func deleteSection(section: Int) {}
//    func showAlert(alertController: UIAlertController) {}
//    //func reloadData() {}
//}


class BaseExpandView: UIView {
    var section: Int!
    var item: CartItem!
    var delegate: BaseExpandable?
    
    let containerView = UIView()
    let giftboxImageView = UIImageView()
    let productNameLabel = UILabel()
    let nameLabel = UILabel()
    let priceLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderAction)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initUI()
    }
    
    @objc func selectHeaderAction(gestureRecognizer: UITapGestureRecognizer) {
        let cell = gestureRecognizer.view as! BaseExpandView
        delegate?.toggleSection(header: self, section: cell.section)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initUI()
        addConstraint()
    }
    
    func setupUI(cartItem: CartItem, section: Int, delegate: BaseExpandable) {
        self.item = cartItem
        self.congifureImageView(giftboxTypeId: item!.product.giftboxTypeId)
        self.productNameLabel.setupWithTitle(textAlignment: .left,
                                    fontSize: 22,
                                    textColor: grayColor!,
                                    text: item!.product.giftboxTypeName!)
        self.nameLabel.setupWithTitle(textAlignment: .left,
                                    fontSize: 18,
                                    textColor: grayColor!,
                                    text: item!.product.name)
        self.configurePriceLabel(price: item!.product.price)
        self.section = section
        self.delegate = delegate
    }
}


extension BaseExpandView {
    
    func congifureImageView(giftboxTypeId: Int?) {
        if giftboxTypeId != nil {
            let url = URL(string: String(describing: giftboxTypeId!).giftBoxUrl())
            self.giftboxImageView.kf.setImage(with: url)
        } else {
            self.giftboxImageView.backgroundColor = grayColor
        }
    }
    
    func configurePriceLabel(price: Int) {
        let amountText = NSMutableAttributedString(string: "單價 $\(price)")
        
        amountText.setAttributes([.font: UIFont.systemFont(ofSize: 16)],
                                 range: NSRange(location: 0, length: 2))
        
        
        priceLabel.attributedText = amountText
        priceLabel.textColor = grayColor
    }
}

private extension BaseExpandView {
    func initUI() {
        containerView.backgroundColor = .white
        
        giftboxImageView.makeShadow(shadowOpacity: 0.3, shadowOffsetH: 0.3)
        giftboxImageView.contentMode = .scaleAspectFill
        
        backgroundColor = .clear
        
        addSubview(containerView)
        containerView.addSubViews(views: giftboxImageView, productNameLabel, nameLabel, priceLabel)
        
        containerView.makeShadow(cornerRadius: 20, shadowOpacity: 0.3, shadowOffsetW: 0.2, shadowOffsetH: 0.2)
    }
    
    func addConstraint() {
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }

        giftboxImageView.snp.makeConstraints { make in
            make.width.equalTo(175)
            make.top.left.bottom.equalToSuperview().inset(20)
        }
        
        productNameLabel.snp.makeConstraints { make in
            make.left.equalTo(giftboxImageView.snp.right).offset(20)
            make.centerY.equalToSuperview().offset(-50)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(productNameLabel.snp.left)
            make.centerY.equalTo(productNameLabel.snp.bottom).offset(15)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.left.equalTo(productNameLabel.snp.left)
            make.centerY.equalTo(nameLabel.snp.bottom).offset(30)
        }
    }
}

class SendOrderExpandView: BaseExpandView {
    
    let countLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        containerView.removeFromSuperview()
        backgroundColor = .white
        countLabel.setup(textAlignment: .left, fontSize: 18, textColor: grayColor)
        makeShadow(shadowOpacity: 0.1, shadowOffsetW: 0.1, shadowOffsetH: 0.1)
        addSubViews(views: giftboxImageView, productNameLabel, nameLabel, priceLabel, countLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {

        giftboxImageView.snp.makeConstraints { make in
            make.width.equalTo(175)
            make.top.bottom.equalToSuperview().inset(20)
            make.left.equalToSuperview().offset(30)
        }
        
        productNameLabel.snp.makeConstraints { make in
            make.left.equalTo(giftboxImageView.snp.right).offset(20)
            make.centerY.equalToSuperview().offset(-50)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(productNameLabel.snp.left)
            make.centerY.equalTo(productNameLabel.snp.bottom).offset(15)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.left.equalTo(productNameLabel.snp.left)
            make.centerY.equalTo(nameLabel.snp.bottom).offset(30)
        }
        
        countLabel.snp.makeConstraints {
            $0.left.equalTo(priceLabel.snp.right).offset(20)
            $0.bottom.equalTo(priceLabel.snp.bottom)
        }
    }
    
    func setupCountText(with count: Int) {
        let countText = NSMutableAttributedString(string: "X \(count) 個")
        countText.setAttributes([.font: UIFont.systemFont(ofSize: 14)],
                                 range: NSRange(location: 4, length: 1))
        countLabel.attributedText = countText

    }
    
}


