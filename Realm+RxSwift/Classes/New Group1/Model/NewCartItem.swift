//
//  NewCartItem.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/21.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import ObjectMapper

struct NewCartItem: Mappable {
    var count: String!
    var subtotal: String!
    var cartId: String!
    var productId: String!
    var pickedItems: [NewPickItem]!
    
    init?(map: Map) {
        
    }
    
    init(count: String, subtotal: String, cartId: String, productId: String, pickedItems: [NewPickItem]) {
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
    var count: String!
    var foodId: String!
    var index: Int = 0
    
    init?(map: Map) {
        
    }
    
    init(count: String, foodId: String) {
        self.count = count
        self.foodId = foodId
    }
    
    mutating func mapping(map: Map) {
        count     <- map["Count"]
        foodId    <- map["FoodId"]
    }
}
