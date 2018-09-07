//
//  ProductListViewModel.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/28.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import Foundation
import RxFlow
import RxSwift

class ProductListViewModel {
    
    let services: AppServices
    
    let cartSections: Observable<[CartItem]>
    let totalPrice: Observable<String>
    
    init(services: AppServices) {
        self.services = services
        
        self.cartSections = services.cartService.getCartItems()
            .catchErrorJustReturn([])
        
        self.totalPrice = services.cartService.getCartItems()
            .map { items -> String in
                let total = items.map{$0.subtotal}.reduce(0,{ $0 + $1})
                
                return "$\(total)"
            }
            .catchErrorJustReturn("0.00")
    }
}

extension ProductListViewModel: Stepper {
    public func goForm() {
        self.step.accept(InHeartStep.form)
    }
}
