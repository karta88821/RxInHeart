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
    
    let services: AppServices
    
    let products: Observable<[CartItem]>
    
    init(services: AppServices) {
        self.services = services
        
        self.products = services.modifyCartItemService.getCartItems()
                                .catchErrorJustReturn([])
    }
}



