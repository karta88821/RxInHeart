//
//  FoodCart.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/21.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import ObjectMapper
import AutoEquatable

struct Food_cart: Mappable {
    private var id: Int!
    private var name: String!
    private var foodCategoryId: Int!
    private var foodCategoryName: String!

    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id                   <- map["Id"]
        name                 <- map["Name"]
        foodCategoryId       <- map["FoodCategoryId"]
        foodCategoryName     <- map["FoodCategoryName"]
    }
}

extension Food_cart: AutoEquatable {}

extension Food_cart {
    func getId() -> Int { return id }
    func getName() -> String { return name }
    func getFoodCategoryId() -> Int { return foodCategoryId }
    func getFoodCategoryName() -> String { return foodCategoryName }
}
