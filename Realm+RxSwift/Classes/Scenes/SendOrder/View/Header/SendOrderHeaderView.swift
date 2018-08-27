//
//  SendOrderHeaderView.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/24.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit

enum SectionType {
    case delivery(title: String, state: String)
    case payment(title: String, state: String)
    case number(number: Int, date: Date)
}

class SectionHeaderView: UIView {
    
    var titleLabel: UILabel!
    var stateLabel: UILabel!
    let sepView = UIView()
    
    var type: SectionType? {
        didSet {
            updateUI()
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
    
    func updateUI() {
        guard let type = type else { return }
        switch type {
        case let .delivery(title, state):
            setupUI(with: title, and: state)
        case let .payment(title, state):
            setupUI(with: title, and: state)
        case let .number(number, date):
            setupDateUI(with: "訂單編號：\(number)", and: date)
        }
    }


}

private extension SectionHeaderView {
    
    func initUI() {
        backgroundColor = .white
        sepView.backgroundColor = sepBackground
        addSubViews(views: sepView)
    }
    
    private func setupUI(with titleText: String, and stateText: String) {
        self.titleLabel = UILabel(alignment: .left, text: titleText)
        self.stateLabel = UILabel(alignment: .right, text: stateText)
        addSubViews(views: titleLabel, stateLabel)
        constraintUI()
    }
    
    private func setupDateUI(with numberText: String, and date: Date) {
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "yyyy/MM/dd"
        let stringOfDate = dateFormate.string(from: date)
        let dateCompleteText = "結帳日期：\(stringOfDate)"
        
        self.titleLabel = UILabel(alignment: .left, text: numberText)
        self.stateLabel = UILabel(alignment: .right, text: dateCompleteText)
        addSubViews(views: titleLabel, stateLabel)
        constraintUI()
    }
    
    private func constraintUI() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        stateLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.right.equalToSuperview().inset(20)
        }
        sepView.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}
