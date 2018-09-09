//
//  PickedItemCart.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/21.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import RxDataSources
import AutoEquatable

struct PickedItem_cart: Codable { 
    var id: Int
    var count: Int
    var foodId: Int
    var cartItemId: Int
    var food: FoodEntity?
    
    private enum PickItemCodingKeys: String, CodingKey {
        case id = "Id"
        case count = "Count"
        case foodId = "FoodId"
        case cartItemId = "CartItemId"
        case food = "Food"
    }
    
    init(id: Int, count: Int, foodId: Int, cartItemId: Int) {
        self.id = id
        self.count = count
        self.foodId = foodId
        self.cartItemId = cartItemId
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PickItemCodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        count = try container.decode(Int.self, forKey: .count)
        foodId = try container.decode(Int.self, forKey: .foodId)
        cartItemId = try container.decode(Int.self, forKey: .cartItemId)
        food = try container.decode(FoodEntity.self, forKey: .food)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: PickItemCodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(count, forKey: .count)
        try container.encode(foodId, forKey: .foodId)
        try container.encode(cartItemId, forKey: .cartItemId)
        //try container.encode(food, forKey: .food)
    }
}

extension PickedItem_cart
    : IdentifiableType
, AutoEquatable{
    typealias Identity = Int
    
    var identity: Int {
        return id
    }
}

