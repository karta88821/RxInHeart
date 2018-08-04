//
//  FoodsCollectionViewCell.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/26.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import SnapKit
import Kingfisher

class FoodsCollectionViewCell: UICollectionViewCell {
    
    var food: Food_cart!
    var foodLabel: UILabel!
    
    let foodImageView = UIImageView()
    
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
    
    func initUI() {
        
        foodImageView.contentMode = .scaleAspectFit
        
        let label = UILabel()
        label.setup(fontSize: 15)
        label.numberOfLines = 0
        self.foodLabel = label
        
        addSubViews(views: foodLabel, foodImageView)
        backgroundColor = pinkBackground!
    }
    
    func constraintUI() {
        foodLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10)
        }
        
        foodImageView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(80)
        }
    }
    
    func setImage(id: Int) {
        let string = String(id).foodUrl()
        let url = URL(string: string)
        foodImageView.kf.setImage(with: url)
    }
}
