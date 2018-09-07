//
//  ModifyCartItemService.swift
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

protocol HasCartService {
    var cartService: CartService { get }
}

class CartService {
    private let `$`: Dependencies
    private let provider: MoyaProvider<ApiManager>
    
    init(`$`: Dependencies, provider: MoyaProvider<ApiManager>) {
        self.`$` = `$`
        self.provider = provider
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
