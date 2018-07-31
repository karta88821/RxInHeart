//
//  FoodCart.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/21.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import ObjectMapper

struct Food_cart: Mappable {
    var id: Int!
    var name: String!
    var foodCategoryId: Int!
    var foodCategoryName: String!

    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id                   <- map["Id"]
        name                 <- map["Name"]
        foodCategoryId       <- map["FoodCategoryId"]
        foodCategoryName     <- map["FoodCategoryName"]
    }
}

extension Food_cart: Equatable {
    static func ==(lhs: Food_cart, rhs: Food_cart) -> Bool {
        return (lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.foodCategoryId == rhs.foodCategoryId &&
            lhs.foodCategoryName == rhs.foodCategoryName)
    }
}
