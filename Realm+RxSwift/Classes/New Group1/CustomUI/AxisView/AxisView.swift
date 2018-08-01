//
//  AxisView.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/28.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import SnapKit

fileprivate let axisWidth: CGFloat = 3.5

class CircleView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundColor = pinkBackground!
        makeBorder(width: axisWidth, color: pinkLine!)
        makeCircle()
    }
}

class IndexCircleView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makeCircle()
        backgroundColor = pinkLine!
    }
}

enum CirclePosition {
    case left
    case middle
    case right
}

class BaseAxisView: UIView {
    
    var position: CirclePosition = .left
    
    let leftCircleView = CircleView()
    let midCircleView = CircleView()
    let rightCircleView = CircleView()
    let lineView = UIView()
    let leftLabel = UILabel()
    let midLabel = UILabel()
    let rightLabel = UILabel()
    
    let indexCircleView = IndexCircleView()

    private let centerYoffset: CGFloat = 15
    private let spacing: CGFloat = 125
    private let circleSize: CGFloat = 30
    let indexCircleSize: CGFloat = 18
    
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
        addIndexCircle()
    }
    
    private func initUI() {
        backgroundColor = pinkBackground
        lineView.backgroundColor = pinkLine
        leftLabel.setupWithTitle(text: "商品清單")
        midLabel.setupWithTitle(text: "運送/付款資訊")
        rightLabel.setupWithTitle(text: "送出訂單")
        
        addSubViews(views: leftCircleView, midCircleView, rightCircleView, leftLabel, midLabel, rightLabel)
        insertSubview(lineView, belowSubview: midCircleView)
        
        addSubview(indexCircleView)
    }
    
    private func constraintUI() {
        leftCircleView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(centerYoffset)
            $0.centerX.equalToSuperview().inset(-spacing)
            $0.height.width.equalTo(circleSize)
        }
        midCircleView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(centerYoffset)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(circleSize)
        }
        
        rightCircleView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(centerYoffset)
            $0.centerX.equalToSuperview().inset(spacing)
            $0.height.width.equalTo(circleSize)
        }
        
        lineView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(centerYoffset)
            $0.left.equalTo(leftCircleView.snp.right)
            $0.right.equalTo(rightCircleView.snp.left)
            $0.height.equalTo(axisWidth)
        }
        
        leftLabel.snp.makeConstraints {
            $0.bottom.equalTo(leftCircleView.snp.top).offset(-5)
            $0.centerX.equalTo(leftCircleView.snp.centerX)
        }
        midLabel.snp.makeConstraints {
            $0.bottom.equalTo(midCircleView.snp.top).offset(-5)
            $0.centerX.equalTo(midCircleView.snp.centerX)
        }
        rightLabel.snp.makeConstraints {
            $0.bottom.equalTo(rightCircleView.snp.top).offset(-5)
            $0.centerX.equalTo(rightCircleView.snp.centerX)
        }
    }
    
    private func addIndexCircle() {
        
        indexCircleView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(centerYoffset)
            $0.height.width.equalTo(indexCircleSize)
            
            switch position {
            case .left:
                $0.centerX.equalTo(leftCircleView.snp.centerX)
            case .middle:
                $0.centerX.equalTo(midCircleView.snp.centerX)
            case .right:
                $0.centerX.equalTo(rightCircleView.snp.centerX)
            }
        }

    }
}
