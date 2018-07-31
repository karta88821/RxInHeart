//
//  DetailCollectionViewCell.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/4/1.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import RxSwift
import Reusable

class DetailCollectionViewCell: UICollectionViewCell, Reusable {
    
    // MARK : - UI
    let textLabel = UILabel()
    
    private(set) var disposeBag = DisposeBag()
    
    var itemModel: GiftBoxViewModel! {
        didSet {
            updateUI()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            textLabel.textColor = isSelected ? .red : grayColor
        }
    }
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        textLabel.text = nil
    }
}

private extension DetailCollectionViewCell {
    func initUI() {

        contentView.backgroundColor = pinkCvCellBackground

        textLabel.setup(textAlignment: .center, fontSize: 16, textColor: grayColor)
        
        contentView.addSubview(textLabel)
    }
    
    func constraintUI() {
        textLabel.snp.makeConstraints{ $0.center.equalToSuperview() }
    }
    
    func updateUI() {
        let categoryName = itemModel.foodCategoryName
        textLabel.text = categoryName + " " + String(itemModel.count) + "個"
    }
}
