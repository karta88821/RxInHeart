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
    public func goShoppingNote() {
        self.step.accept(InHeartStep.shoppingNote)
    }
}
