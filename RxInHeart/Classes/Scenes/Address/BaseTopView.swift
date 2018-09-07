//
//  BaseTopView.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/4.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import SnapKit

let addressMargin: CGFloat = 40

class BaseTopView: UIView {
    
    // MARK : - UI
    let leftLabel = UILabel()
    let rightLabel = UILabel()
    let sepLayer = CALayer()
    
    enum LabelPostion {
        case left
        case right
    }
    
    var highlightedPosition: LabelPostion? {
        didSet {
            updateTextColor()
        }
    }

    var indexTextColor: UIColor? {
        didSet {
            updateTextColor()
        }
    }

    private let titles = ["1.填寫地址","2.選擇宅配數量"]
    private let sepViewH: CGFloat = 1
    
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
    
    func configureSepLayer(y: CGFloat) {
        sepLayer.frame = CGRect(
            x: 0,
            y: y,
            width: frame.size.width,
            height: 1)
    }
}

private extension BaseTopView {
    
    func initUI() {
        backgroundColor = .white
        sepLayer.backgroundColor = UIColor.lightGray.cgColor
        
        leftLabel.textAlignment = .left
        leftLabel.font = UIFont.systemFont(ofSize: 20)
        leftLabel.text = titles[0]
        rightLabel.textAlignment = .left
        rightLabel.font = UIFont.systemFont(ofSize: 20)
        rightLabel.text = titles[1]
        addSubViews(views: leftLabel, rightLabel)
        layer.addSublayer(sepLayer)
    }
    
    func constraintUI() {
        leftLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(addressMargin)
        }
        
        rightLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(leftLabel.snp.right).offset(addressMargin)
        }
    }
    
    func updateTextColor() {
        
        if let position = highlightedPosition {
            switch position {
            case .left:
                leftLabel.textColor = textFieldTitleColor
                rightLabel.textColor = grayColor
            case .right:
                leftLabel.textColor = grayColor
                rightLabel.textColor = textFieldTitleColor
            }
        }
        
    }
}

