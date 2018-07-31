//
//  CartViewModel.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/4/11.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import Foundation
import RxFlow
import RxSwift
import RxCocoa

class CartViewModel: ServicesViewModel  {
    
    var services: Service!
    
    let items: Driver<[CartItemViewModel]>
    
    init() {
        
        let _items = DBManager.query(RMCart.self)
        
        self.items = Observable.from(optional: _items)
            .asDriver(onErrorDriveWith: .empty())
            .map { results -> [CartItemViewModel] in
                results.map {
                    let cartViewModel = CartModel(with: $0)
                    let cartItemViewModels = Array($0.details)
                        .map { CartItemModel(with: $0)}
                    
                    return CartItemViewModel(model: cartViewModel, detail: cartItemViewModels)
                }
        }
    }
}

extension CartViewModel: Stepper {

}

