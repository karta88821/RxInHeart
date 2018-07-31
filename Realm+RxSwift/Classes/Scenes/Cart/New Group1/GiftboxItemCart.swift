//
//  GiftboxItemCart.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/21.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import ObjectMapper

struct GiftboxItem_cart: Mappable {
    var id: Int!
    var foodCategoryName: String!
    var foodCategoryId: Int!
    var count: Int!
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id                  <- map["Id"]
        foodCategoryName    <- map["FoodCategoryName"]
        foodCategoryId      <- map["FoodCategoryId"]
        count               <- map["Count"]
    }
}

extension GiftboxItem_cart: Equatable {}

func ==(lhs: GiftboxItem_cart, rhs: GiftboxItem_cart) -> Bool {
    return lhs.id == rhs.id &&
        lhs.foodCategoryName == rhs.foodCategoryName &&
        lhs.foodCategoryId == rhs.foodCategoryId &&
        lhs.count == rhs.id
}
