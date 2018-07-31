//
//  LogoutView.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/12.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit

class LogoutView: UIView {
    
    let profileImageView = UIView()
    let logoutButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initUI()
        constraintUI()
    }
    
    private func initUI() {
        backgroundColor = pinkBackground
        
        profileImageView.backgroundColor = .gray
        profileImageView.layer.cornerRadius = 50
        profileImageView.layer.masksToBounds = false

        logoutButton.setup(title: "Logout", textColor: grayColor)
        
        addSubViews(views: profileImageView, logoutButton)
    }
    
    private func constraintUI() {
        profileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-15)
            $0.height.width.equalTo(100)
        }
        logoutButton.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(5)
            $0.centerX.equalTo(profileImageView.snp.centerX)
        }
    }
}
