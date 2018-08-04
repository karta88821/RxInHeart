//
//  PickedItemCart.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/21.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import ObjectMapper

struct PickedItem_cart: Mappable {
    var id: Int!
    var count: Int!
    var foodId: Int!
    var cartItemId: Int!
    var food: Food_cart!
    
    init(id: Int, count: Int, foodId: Int, cartItemId: Int) {
        self.id = id
        self.count = count
        self.foodId = foodId
        self.cartItemId = cartItemId
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id         <- map["Id"]
        count      <- map["Count"]
        foodId     <- map["FoodId"]
        cartItemId <- map["CartItemId"]
        food       <- map["Food"]
    }
}


