//
//  AllocateCell.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/5.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class AllocateCell: UITableViewCell {
    
    private var limitCount = 12

    let giftBoxImageView = UIImageView()
    let productLabel = UILabel(alignment: .left, fontSize: 20)
    let giftBoxLabel = UILabel(alignment: .left)
    let moreButton = UIButton()
    let countLabel = UILabel(alignment: .right, fontSize: 20, textColor: darkRed)
    
    var item: CartItem?
    var frameSizes: [CGFloat]?
    var totalCount: Int = 0
    var newTotal: Int = 0
    var selectedCount: Int = 0
    
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
        super.layoutSubviews()
        makeConstraints()
    }
    
    func setupUI(cartItem: CartItem, selectedCount: Int) {
        guard let product = cartItem.product else { return }
        self.item = cartItem
        let url = URL(string: String(product.giftboxTypeId).giftBoxUrl())
        self.giftBoxImageView.kf.setImage(with: url)
        self.productLabel.text = product.name
        self.giftBoxLabel.text = product.giftboxTypeName ?? "沒有禮盒"
        self.totalCount = cartItem.count
        self.selectedCount = selectedCount
        self.countLabel.text = "0/\(totalCount - selectedCount)"
        self.frameSizes = (0...cartItem.count - selectedCount).filter{$0 % 12 == 0}.map{CGFloat($0)}
        
        self.newTotal = totalCount - selectedCount
        
        isUserInteractionEnabled = (totalCount - selectedCount == 0) ? false : true
    }
    
}

private extension AllocateCell {
    func initUI() {
        giftBoxImageView.makeShadow(shadowOpacity: 0.3, shadowOffsetW: 0.3, shadowOffsetH: 0.3)
        giftBoxImageView.contentMode = .scaleAspectFill
       
        let attributeString = NSAttributedString(string: "顯示更多",
                                                 attributes: [.foregroundColor: darkRed!, .font:  UIFont.systemFont(ofSize: 16)])
        moreButton.setAttributedTitle(attributeString, for: .normal)
        moreButton.addTarget(self, action: #selector(moreAction(_:)), for: .touchUpInside)

        contentView.addSubViews(views: giftBoxImageView, productLabel, giftBoxLabel, moreButton, countLabel)
        contentView.makeShadow(shadowOpacity: 0.1, shadowOffsetW: 0.1, shadowOffsetH: 0.1)
        contentView.backgroundColor = .white
    }
    
    func makeConstraints() {
        giftBoxImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(15)
            $0.left.equalToSuperview().inset(40)
            $0.width.equalTo(120)
        }
        
        productLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-10)
            $0.left.equalTo(giftBoxImageView.snp.right).offset(30)
        }
        
        giftBoxLabel.snp.makeConstraints {
            $0.top.equalTo(productLabel.snp.bottom).offset(5)
            $0.left.equalTo(productLabel.snp.left)
        }
        
        countLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(20)
        }
        
        moreButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(10)
        }
        
    }
    
    @objc func moreAction(_ sender: AnyObject) {
        guard let cartItem = item else { return }
        delegate?.showPopup(item: cartItem, deliveryInfo: nil)
    }
}
