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
    
    var services: APIDelegate!
    
    let cartSections: Observable<[CartItem]>
    let totalPrice: Observable<String>
    
    init() {
        services = APIClient.sharedAPI
        
        self.cartSections = services.getCartItems()
            .catchErrorJustReturn([])
        
        self.totalPrice = services.getCartItems()
            .map { items -> String in
                let total = items.map{$0.getSubtotal()}.reduce(0,{ $0 + $1})
                
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
