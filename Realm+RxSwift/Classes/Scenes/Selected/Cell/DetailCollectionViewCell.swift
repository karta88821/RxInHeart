//
//  DetailCollectionViewCell.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/4/1.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import RxSwift

class DetailCollectionViewCell: UICollectionViewCell {
    
    // MARK : - UI
    let textLabel = UILabel(alignment: .center, fontSize: 16)
    
    private(set) var disposeBag = DisposeBag()
    
    var itemModel: GiftboxItem! {
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
        constraintUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initUI()
        constraintUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        textLabel.text = nil
    }
    
    func changeFoodText(to foodName: String) {
        textLabel.text = foodName
    }
}

private extension DetailCollectionViewCell {
    func initUI() {
        contentView.backgroundColor = pinkCvCellBackground
        contentView.addSubview(textLabel)
    }
    
    func constraintUI() {
        textLabel.snp.makeConstraints{ $0.center.equalToSuperview() }
    }
    
    func updateUI() {
        let categoryName = itemModel.foodCategoryName
        textLabel.text = textFormat(text: categoryName)
    }
    
    func textFormat(text: String) -> String {
        return text + " \(itemModel.count)個"
    }
 
}
