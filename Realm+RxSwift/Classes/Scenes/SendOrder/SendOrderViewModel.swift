//
//  SendOrderViewModel.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/1.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFlow

class SendOrderViewModel {
    
    let services: AppServices
    
    init(services: AppServices) {
        self.services = services
    }
}

extension SendOrderViewModel: Stepper {
    public func goOrderInfo(with sendModel: SendOrderModel) {
        self.step.accept(InHeartStep.orderDetail(sendModel: sendModel))
    }
}


