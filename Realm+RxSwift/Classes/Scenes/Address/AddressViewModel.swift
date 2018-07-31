//
//  AddressViewModel.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/4.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import RxFlow

class AddressViewModel {
    init() {
        
    }
}

extension AddressViewModel: Stepper {
    public func goAllocate(deliveryInfo: DeliveryInfo) {
        self.step.accept(InHeartStep.allocateProduct(deliveryItem: deliveryInfo))
    }
}
