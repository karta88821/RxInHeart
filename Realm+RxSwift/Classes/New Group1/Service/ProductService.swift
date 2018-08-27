//
//  ProductService.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/8/27.
//  Copyright © 2018 liao yuhao. All rights reserved.
//

import Moya
import RxSwift
import RxCocoa
import Foundation
import ObjectMapper

protocol HasProductsService {
    var productsService: ProductsService { get }
}

class ProductsService {
    private let `$`: Dependencies
    private let provider: MoyaProvider<ApiManager>
    
    init(`$`: Dependencies, provider: MoyaProvider<ApiManager>) {
        self.`$` = `$`
        self.provider = provider
    }
    
    func getFoods() -> Observable<[FoodEntity]> {
        return provider.rx.request(.foods)
            .observeOn(`$`.backgroundWorkScheduler)
            .mapArray(FoodEntity.self)
            .observeOn(`$`.mainScheduler)
            .asObservable()
            .catchErrorJustReturn([])
    }
    
    func getUniqueFoods(categoryId: Int) -> Observable<[Food]> {
        return provider.rx.request(.food(categoryId: categoryId))
            .observeOn(`$`.backgroundWorkScheduler)
            .mapArray(Food.self)
            .observeOn(`$`.mainScheduler)
            .asObservable()
            .catchErrorJustReturn([])
    }
    
    func getProducts() -> Observable<[ProductEntity]> {
        return provider.rx.request(.products)
            .observeOn(`$`.backgroundWorkScheduler)
            .mapArray(ProductEntity.self)
            .observeOn(`$`.mainScheduler)
            .asObservable()
            .catchErrorJustReturn([])
    }
}
