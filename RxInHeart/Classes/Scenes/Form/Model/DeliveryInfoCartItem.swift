//
//  DeliveryInfoCartItem.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/7.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import AutoEquatable

struct DeliveryInfoCartItem {
    let cartItem: CartItem
    var count: Int = 0
}

extension DeliveryInfoCartItem: AutoEquatable {}
