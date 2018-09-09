//
//  NewCartItem.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/21.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import Foundation

protocol NewCartItemRequired {
    var count: Int! {get}
    var subtotal: Int! {get}
    var cartId: Int! {get}
    var productId: Int! {get}
    var pickedItems: [NewPickItemRequired]! {get}
}

protocol NewPickItemRequired {
    var count: Int! {get}
    var foodId: Int! {get}
}

struct NewCartItem: Encodable {
    var count: Int
    var subtotal: Int
    var cartId: Int
    var productId: Int
    var pickedItems: [NewPickItem]
    
    private enum NewCartItemCodingKey: String, CodingKey {
        case count = "Count"
        case subtotal = "Subtotal"
        case cartId = "CartId"
        case productId = "ProductId"
        case pickedItems = "PickedItem"
    }
    
    init(count: Int, subtotal: Int, cartId: Int, productId: Int,
         pickedItems: [NewPickItem]) {
        self.count = count
        self.subtotal = subtotal
        self.cartId = cartId
        self.productId = productId
        self.pickedItems = pickedItems
    }
}

struct NewPickItem: Encodable {
    var count: Int
    var foodId: Int
    var index: Int = 0
    
    private enum NewPickItemCodingKey: String, CodingKey {
        case count = "Count"
        case foodId = "FoodId"
    }

    init(count: Int, foodId: Int) {
        self.count = count
        self.foodId = foodId
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: NewPickItemCodingKey.self)
        try container.encode(count, forKey: .count)
        try container.encode(foodId, forKey: .foodId)
    }

}
