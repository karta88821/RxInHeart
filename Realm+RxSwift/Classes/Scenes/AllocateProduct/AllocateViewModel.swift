//
//  AllocateViewModel.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/4.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa

class AllocateViewModel {
    
    var services: APIDelegate!
    
    let products: Observable<[CartItem]>
    
    init() {
        services = APIClient.sharedAPI
        
        self.products = services.getCartItems()
            .catchErrorJustReturn([])
    }
}



