//
//  AllocateHeaderView.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/20.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import SnapKit

class AllocateHeaderView: UIView {
    
    // MARK : - UI
    let topView = BaseTopView()
    let addtionalView = UIView()
    let addtionalLabel = UILabel(alignment: .right, fontSize: 20)
    
    // MARK : - Property
    private let addtionalText = "宅配量/剩餘量"
    
    // MARK : - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initUI()
    }
    
    // MARK : - Layout subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        constraintUI()
    }
}

private extension AllocateHeaderView {
    
    func initUI() {
        topView.highlightedPosition = .right
        addtionalView.backgroundColor = .white
        addtionalLabel.text = addtionalText
        addSubViews(views: topView, addtionalView)
        addtionalView.addSubview(addtionalLabel)
    }
    
    func constraintUI() {
        topView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(80)
        }
        addtionalView.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.top.equalTo(topView.snp.bottom)
        }
        addtionalLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(10)
        }
    }
}
