//
//  Cart.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/21.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import Foundation

struct Cart: Decodable {
    var id: Int
    var total: Int
    var cartItems: [CartItem]
    
    private enum CartCodingKeys: String, CodingKey {
        case id = "Id"
        case total = "Total"
        case cartItems = "CartItems"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CartCodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        total = try container.decode(Int.self, forKey: .total)
        cartItems = try container.decode([CartItem].self, forKey: .cartItems)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CartCodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(total, forKey: .total)
        try container.encode(cartItems, forKey: .cartItems)
    }
}
