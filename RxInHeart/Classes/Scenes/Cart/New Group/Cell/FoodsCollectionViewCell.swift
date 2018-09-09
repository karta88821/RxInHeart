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
    
    // MARK : - UI
    var foodLabel: UILabel!
    var foodImageView: UIImageView!
    
    // MARK : - Property
    var food: FoodEntity!

    override init(frame: CGRect) {
        super.init(frame: frame)
        createViews()
        configureView()
        constraintUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createViews()
        configureView()
        constraintUI()
    }
    
    func createViews() {
        configureFoodImageView()
        configureFoodLabel()
    }
    
    func configureView() {
        addSubViews(views: foodLabel, foodImageView)
        backgroundColor = pinkBackground!
    }
    
    func configureFoodImageView() {
        foodImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
    }
    
    func configureFoodLabel() {
        foodLabel = {
            let label = UILabel(fontSize: 15, textColor: .black)
            label.numberOfLines = 0
            return label
        }()
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
