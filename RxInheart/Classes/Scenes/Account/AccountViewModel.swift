//
//  AccountViewModel.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/2/23.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import RxFlow

class AccountViewModel {
    
    init() {
        
    }
}

extension AccountViewModel: Stepper {
    public func push(with row: Int) {
        switch row {
        case 0:
            self.step.accept(InHeartStep.shoppingNote)
        case 1:
            self.step.accept(InHeartStep.shoppingNote)
        case 2:
            self.step.accept(InHeartStep.shoppingNote)
        default:
            break
        }
    }
}
