//
//  MainCollectionViewCell.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/3/22.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

class MainCollectionViewCell: UICollectionViewCell {
    
    // MARK : - Property
    var caseModel: CaseModel? {
        didSet {
            updateUI()
        }
    }
    
//    override var isSelected: Bool {
//        didSet {
//            self.caseImageView.layer.borderWidth = isSelected ? 1 : 0
//            self.caseImageView.layer.borderColor = isSelected ? UIColor.red.cgColor : UIColor.clear.cgColor
//        }
//    }
    
    // MARK : - UI
    let caseImageView = UIImageView()
    let caseNameLabel = UILabel()
    let priceAndCountLabel = UILabel()
    
    // MARK : - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        constraintUI()
    }
}


extension MainCollectionViewCell {
    
    func setup(with caseModel: CaseModel) {
        
        let imageString = String(caseModel.giftboxId)
        
        caseNameLabel.text = caseModel.giftboxName
        caseImageView.kf.setImage(with: URL(string: imageString.giftBoxUrl()))
    }
}

private extension MainCollectionViewCell {
    
    func setupPriceLabel(with price: Int, and totalCount: Int) -> String {
        return "$\(price)/\(totalCount)片"
    }
    
    func updateUI() {
        guard let caseModel = caseModel else { return }
        
        let imageString = String(caseModel.giftboxId)
        
        caseNameLabel.text = caseModel.giftboxName
        caseImageView.kf.setImage(with: URL(string: imageString.giftBoxUrl()))
        priceAndCountLabel.text = setupPriceLabel(with: caseModel.price, and: caseModel.totalCount)
    }
    
    func initUI() {
        caseImageView.contentMode = .scaleAspectFill
        caseImageView.sizeToFit()
        caseImageView.makeShadow(cornerRadius: 5)
        caseNameLabel.setup(textAlignment: .left, fontSize: 15, textColor: grayColor)
        priceAndCountLabel.setup(textAlignment: .right, fontSize: 15, textColor: grayColor)

        contentView.addSubViews(views: caseImageView, caseNameLabel, priceAndCountLabel)
    }
    
    func constraintUI() {
        caseImageView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        caseNameLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(5)
        }
        
        priceAndCountLabel.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(5)
        }
    }
}
