//
//  CartViewModel.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/4/15.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import RxDataSources
import RxSwift
import RxCocoa
import RxFlow

class CartViewModel {
    
    let services: AppServices
    
    private let disposeBag = DisposeBag()
    
    var dataSource = RxTableViewSectionedAnimatedDataSource<CartItem>(configureCell: {(_,_,_,_) in
        fatalError()
    }) 
    
    let cartSections: Observable<[CartItem]>
    let subtotal: Observable<String>
    let totalPrice: Observable<String>
    
    init(services: AppServices) {
        
        self.services = services
        
        self.cartSections = services.modifyCartItemService.getCartItems().catchErrorJustReturn([])

        self.subtotal = services.modifyCartItemService.getCartSubtotal()
                                .map{String($0)}
                                .catchErrorJustReturn("0")
        
        self.totalPrice = services.modifyCartItemService.getCartItems()
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
