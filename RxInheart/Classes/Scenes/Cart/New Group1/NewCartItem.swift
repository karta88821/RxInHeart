//
//  NewCartItem.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/21.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import ObjectMapper

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

struct NewCartItem: Mappable {
    var count: Int!
    var subtotal: Int!
    var cartId: Int!
    var productId: Int!
    var pickedItems: [NewPickItem]!
    
    init?(map: Map) {
        
    }
    
    init(count: Int, subtotal: Int, cartId: Int, productId: Int,
         pickedItems: [NewPickItem]) {
        self.count = count
        self.subtotal = subtotal
        self.cartId = cartId
        self.productId = productId
        self.pickedItems = pickedItems
    }
    
    mutating func mapping(map: Map) {
        count        <- map["Count"]
        subtotal     <- map["Subtotal"]
        cartId       <- map["CartId"]
        productId    <- map["ProductId"]
        pickedItems  <- map["PickedItem"]
    }
}

struct NewPickItem: Mappable {
    var count: Int!
    var foodId: Int!
    var index: Int = 0

    init?(map: Map) {

    }

    init(count: Int, foodId: Int) {
        self.count = count
        self.foodId = foodId
    }

    mutating func mapping(map: Map) {
        count     <- map["Count"]
        foodId    <- map["FoodId"]
    }
}
