//
//  DeliveryInfoCartItem.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/7.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import Foundation

class DeliveryInfoCartItem {
    let cartItem: CartItem
    var count: Int
    
    init(cartItem: CartItem, count: Int = 0) {
        self.cartItem = cartItem
        self.count = count
    }
}
