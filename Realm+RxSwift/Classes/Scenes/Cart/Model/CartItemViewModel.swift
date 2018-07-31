//
//  CartItemViewModel.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/4/14.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import Foundation

class CartItemViewModel {
    let cartModel: CartModel
    let cartDetail: [CartItemModel]
    
    init(model:CartModel,detail:[CartItemModel]) {
        self.cartModel = model
        self.cartDetail = detail
    }
}

class CartModel {
    let cart: RMCart
    let compositionId: Int
    let price: Double
    let items: [RMCartDetail]
    init(with cart: RMCart) {
        self.cart = cart
        self.compositionId = cart.compositionId
        self.price = cart.price
        self.items = Array(cart.details)
    }
}

class CartItemModel {
    let cartDetail: RMCartDetail
    let categoryId: Int
    let productId: Int
    let count: Int
    
    init(with cartDetail: RMCartDetail) {
        self.cartDetail = cartDetail
        self.categoryId = cartDetail.categoryId
        self.productId = cartDetail.productId
        self.count = cartDetail.count
    }
}
