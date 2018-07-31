//
//  ExchangeViewModel.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/24.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import RxSwift

class ExchangeViewModel: ServicesViewModel {
    
    var services: APIDelegate!
    
    let foods: Observable<[Food_cart]>
    
    init(categoryId: Int) {
        
        self.services = APIClient.sharedAPI
        
        self.foods = services.getUniqueFoods(categoryId: categoryId)
                        .catchErrorJustReturn([])
        
    }
}
