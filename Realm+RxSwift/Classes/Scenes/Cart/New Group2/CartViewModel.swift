//
//  CartViewModel.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/4/15.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxFlow

class CartViewModel: ServicesViewModel {
    
    var services: APIDelegate!
    
    fileprivate let disposeBag = DisposeBag()
    
    let `$`: Dependencies = Dependencies.sharedDependencies
    
    let cartSections: Observable<[CartItem]>
    let subtotal: Observable<String>
    let totalPrice: Observable<String>
    
    init() {
        
        services = APIClient.sharedAPI
        
        self.cartSections = services.getCartItems()
                            .catchErrorJustReturn([])
        
        self.subtotal = services.getCartSubtotal()
                                .map{String($0)}
                                .catchErrorJustReturn("0")
        
        self.totalPrice = services.getCartItems()
                                .map { items -> String in
                                    let total = items.map{$0.subtotal}.reduce(0,{ $0 + $1})
            
                                    return "$\(total)"
                                }
                                .catchErrorJustReturn("0.00")
    }
}

extension CartViewModel: Stepper {
    
    public func goProductList() {
        self.step.accept(InHeartStep.productList)
    }
}
