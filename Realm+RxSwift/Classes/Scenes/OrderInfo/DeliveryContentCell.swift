//
//  DeliveryContentCell.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/28.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit

class DeliveryContentCell: InfoCell {
    
    // MARK : - UI
    var bottomView: UIView!
    var contentTitleLabel: UILabel!
    var contentButton: UIButton!
    
    // MARK : - Property
    var deliveryInfo: DeliveryInfo?
    
    // MARK : - Delegate
    var delegate: PopViewPresentable?
    
    // MARK : - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView(for: contentView)
        constraintUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView(for: contentView)
        constraintUI()
    }

    func setupUI(with deliveryInfo: DeliveryInfo) {
        
        self.deliveryInfo = deliveryInfo
        
        stackView.removeAllArrangedSubviews()
        
        let deliveryInfoList = [("收貨人", deliveryInfo.name),
                                ("聯絡電話", deliveryInfo.phone),
                                ("宅配地址", deliveryInfo.address)]
        
        for (key, value) in deliveryInfoList {
            let titleLabel = UILabel(alignment: .left, text: key)
            let infoLabel = UILabel(alignment: .right, text: value)

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
    
    func createViews() {
        configureBottomView()
        configureLabel()
        configureContentButton()
    }
    
    func configureView(for view: UIView) {
        createViews()
        view.addSubview(bottomView)
        bottomView.addSubViews(views: contentTitleLabel, contentButton)
    }
    
    func configureBottomView() {
        bottomView = UIView(backgroundColor: .white)
    }
    
    func configureLabel() {
         contentTitleLabel = UILabel(alignment: .left, text: "宅配內容")
    }
    
    func configureContentButton() {
        
        let attributeString = NSAttributedString(string: "內容",
                                                 attributes: [.font: UIFont.systemFont(ofSize: 16),
                                                              .foregroundColor: textFieldTitleColor!])
        contentButton = {
            let button = UIButton()
            button.setAttributedTitle(attributeString, for: .normal)
            button.addTarget(self, action: #selector(popAction(_:)), for: .touchUpInside)
            
            return button
        }()

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
