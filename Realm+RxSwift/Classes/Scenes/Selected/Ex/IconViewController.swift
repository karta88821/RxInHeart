//
//  IconViewController.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/5/23.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import Kingfisher

class IconViewController: UIViewController {
    
    // MARK : - UI
    let foodImageView = UIImageView()
    let foodLabel = UILabel(alignment: .center, fontSize: 20)
    var foodId: Int!
    
    // MARK : - Initialization
    init(foodName: String, foodId: Int) {
        super.init(nibName: nil, bundle: nil)
        self.foodId = foodId
        
        let url = URL(string: String(foodId).foodUrl())
        foodImageView.kf.setImage(with: url)
        foodLabel.text = foodName
        
        initUI()
        constraintsUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initUI()
        constraintsUI()
    }
}

fileprivate extension IconViewController {
    
    func initUI() {
        foodImageView.contentMode = .scaleAspectFit
        foodImageView.sizeToFit()
        
        view.addSubViews(views: foodImageView, foodLabel)
        view.backgroundColor = .white
    }
    
    func constraintsUI() {
        foodImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-15)
            make.width.height.equalTo(90)
        }
        foodLabel.snp.makeConstraints { make in
            make.top.equalTo(foodImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
        }
    }
}
