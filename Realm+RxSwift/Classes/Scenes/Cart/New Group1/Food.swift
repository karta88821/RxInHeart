//
//  Food.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/21.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import ObjectMapper
import AutoEquatable

struct Food: Mappable {
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

extension Food: AutoEquatable {}

//extension Food {
//    func getId() -> Int { return id }
//    func getName() -> String { return name }
//    func getFoodCategoryId() -> Int { return foodCategoryId }
//    func getFoodCategoryName() -> String { return foodCategoryName }
//}
