//
//  PaymentHeaderView.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/2.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import SnapKit

enum PaymentState: String {
    case ATM = "ATM轉帳"
    case online = "線上付款"
    
    func getString() -> String {
        switch self {
        case .ATM:
            return PaymentState.ATM.rawValue
        case .online:
            return PaymentState.online.rawValue
        }
    }
}

class PaymentHeaderView: BaseHeader {
    
    // MARK : Properies
    var state: PaymentState = .ATM
    
    private let payments: [PaymentState] = [.ATM, .online]
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {

        dropButton.setup(title: state.rawValue, textColor: .black)
        dropDown.dataSource = payments.map{$0.getString()}
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.dropButton.setTitle(item, for: .normal)
            if let selectedState = self?.payments[index] {
                self?.state = selectedState
            }
        }
    }
}
