//
//  APIClient.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/12.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import Moya
import RxSwift
import RxCocoa
import Foundation
import ObjectMapper

protocol APIDelegate {
    func getFoods() -> Observable<[FoodEntity]>
    func getUniqueFoods(categoryId: Int) -> Observable<[Food_cart]>
    func getProducts() -> Observable<[ProductEntity]>
    func getCartItems() -> Observable<[CartItem]>
    func getCartSubtotal() -> Observable<Int>
    func addItem(item: NewCartItem) -> Observable<Bool>
    func updateItem(cartItemId: Int, item: CartItem) -> Observable<Bool>
    func deleteItem(cartItemId: Int) -> Observable<Bool>
}

class APIClient: APIDelegate {

    static let sharedAPI = APIClient()
    
    private let provider = MoyaProvider<ApiManager>()
    
    let `$`: Dependencies = Dependencies.sharedDependencies
    
    private init() {}
    
    func getFoods() -> Observable<[FoodEntity]> {
        return provider.rx.request(.foods)
                .observeOn(`$`.backgroundWorkScheduler)
                .mapArray(FoodEntity.self)
                .observeOn(`$`.mainScheduler)
                .asObservable()
                .catchErrorJustReturn([])
    }
    
    func getUniqueFoods(categoryId: Int) -> Observable<[Food_cart]> {
        return provider.rx.request(.food(categoryId: categoryId))
                .observeOn(`$`.backgroundWorkScheduler)
                .mapArray(Food_cart.self)
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
    
    private func getCart() -> Observable<Cart> {
        return provider.rx.request(.cart)
                .observeOn(`$`.backgroundWorkScheduler)
                .mapObject(Cart.self)
                .observeOn(`$`.mainScheduler)
                .asObservable()
                .catchError{_ in return Observable<Cart>.empty()}
    }
    
    func getCartItems() -> Observable<[CartItem]> {
        return getCart()
                .observeOn(`$`.backgroundWorkScheduler)
                .map {$0.cartItems}
                .observeOn(`$`.mainScheduler)
    }
    
    func getCartSubtotal() -> Observable<Int> {
        return getCart()
                .observeOn(`$`.backgroundWorkScheduler)
                .map{$0.total}
                .observeOn(`$`.mainScheduler)
    }
    
    func addItem(item: NewCartItem) -> Observable<Bool> {
        
        return provider.rx.request(.addCartItem(cartId: 1, item: item))
            .asObservable()
            .observeOn(`$`.backgroundWorkScheduler)
            .flatMap { response -> Observable<Bool> in
                if response.response?.statusCode == 200 {
                    return Observable.just(true)
                } else {
                    return Observable.just(false)
                }
            }
            .observeOn(`$`.mainScheduler)
            .catchErrorJustReturn(false)
    
    }
    
    func updateItem(cartItemId: Int, item: CartItem) -> Observable<Bool> {
        
        return provider.rx.request(.updateCart(cartId: 1, cartItemId: cartItemId, cartItem: item))
                .asObservable()
                .observeOn(`$`.backgroundWorkScheduler)
                .flatMap { response -> Observable<Bool> in
                    print(response.response?.statusCode ?? 0)
                    if response.response?.statusCode == 200 {
                        return Observable.just(true)
                    } else {
                        return Observable.just(false)
                    }
                }
                .observeOn(`$`.mainScheduler)
                .catchErrorJustReturn(false)
    }
    
    func deleteItem(cartItemId: Int) -> Observable<Bool> {
        return provider.rx.request(.deleteCartItem(cartId: 1, cartItemId: cartItemId))
                .asObservable()
                .observeOn(`$`.backgroundWorkScheduler)
                .flatMap { response -> Observable<Bool> in
                    if response.response?.statusCode == 200 {
                        return Observable.just(true)
                    } else {
                        return Observable.just(false)
                    }
                }
                .observeOn(`$`.mainScheduler)
                .catchErrorJustReturn(false)
    }
}
