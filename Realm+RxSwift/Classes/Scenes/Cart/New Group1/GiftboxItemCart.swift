//
//  GiftboxItemCart.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/21.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import ObjectMapper
import AutoEquatable

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

extension GiftboxItem_cart: AutoEquatable {}

//extension GiftboxItem_cart {
//    func getId() -> Int { return id }
//    func getFoodCategoryName() -> String { return foodCategoryName }
//    func getFoodCategoryId() -> Int { return foodCategoryId }
//    func getCount() -> Int { return count }
//}
