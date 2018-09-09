//
//  ExchangeViewModel.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/24.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import RxSwift

class ExchangeViewModel {
    
    let services: AppServices
    
    let foods: Observable<[FoodEntity]>
    
    init(categoryId: Int, services: AppServices) {
        
        self.services = services
        
        self.foods = services.productsService
                        .getUniqueFoods(categoryId: categoryId).asObservable()
                        .catchErrorJustReturn([])
        
    }
}
