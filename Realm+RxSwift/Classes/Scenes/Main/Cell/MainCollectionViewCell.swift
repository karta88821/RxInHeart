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
    var caseModel: CasePresentable? {
        didSet {
            updateUI()
        }
    }

    // MARK : - UI
    let caseImageView = UIImageView()
    let bottomView = UIView()
    let caseNameLabel = UILabel()
    let priceAndCountLabel = UILabel()
    
    // MARK : - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        constraintUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initUI()
        constraintUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        caseModel = nil
//        caseImageView.image = nil
//        caseNameLabel.text = nil
//        priceAndCountLabel.text = nil
    }
}

private extension MainCollectionViewCell {
    
    func updateUI() {
        guard let caseModel = caseModel else { return }
        
        let imageString = String(caseModel.giftboxId)
        
        caseNameLabel.text = caseModel.giftboxName
        caseImageView.kf.indicatorType = .activity
        caseImageView.kf.setImage(with: URL(string: imageString.giftBoxUrl()),
                                  placeholder: UIImage(named: "default"))
        
        priceAndCountLabel.text = setupPriceLabel(with: caseModel.giftboxId,
                                                  caseModel.price, caseModel.totalCount)
    }
    
    func initUI() {
        caseImageView.contentMode = .scaleToFill
        bottomView.backgroundColor = .white
        caseNameLabel.setup(textAlignment: .left, fontSize: 15, textColor: grayColor)
        priceAndCountLabel.setup(textAlignment: .right, fontSize: 15, textColor: grayColor)

        contentView.addSubViews(views: caseImageView, bottomView)
        bottomView.addSubViews(views: caseNameLabel, priceAndCountLabel)
    }
    
    func constraintUI() {
        
        bottomView.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        caseImageView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.bottom.equalTo(bottomView.snp.top)
        }
        
        caseNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
        }
        
        priceAndCountLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
        }
    }
    
    func setupPriceLabel(with giftBoxId: Int, _ price: Int,_ totalCount: Int) -> String? {
        switch giftBoxId {
        case 1,2,3:
            return "$\(price)/\(totalCount)片"
        case 0:
            return "$\(price)元"
        default:
            return nil
        }
    }
    
}

//    override var isSelected: Bool {
//        didSet {
//            self.caseImageView.layer.borderWidth = isSelected ? 1 : 0
//            self.caseImageView.layer.borderColor = isSelected ? UIColor.red.cgColor : UIColor.clear.cgColor
//        }
//    }
