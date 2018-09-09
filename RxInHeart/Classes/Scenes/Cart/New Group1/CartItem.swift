//
//  CartItem.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/21.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import RxDataSources
import AutoEquatable
import Foundation

struct CartItem {
    var id: Int
    var count: Int
    var subtotal: Int
    var productId: Int
    var product: ProductEntity?
    var cartId: Int
    
    var pickedItem: [PickedItem_cart]
    
    var expanded: Bool = false

    private enum CartItemCodingKeys: String, CodingKey {
        case id = "Id"
        case count = "Count"
        case subtotal = "SubTotal"
        case pickedItem = "PickedItem"
        case productId = "ProductId"
        case product = "Product"
        case cartId = "CartId"
    }
    
    init(id: Int, count: Int, subtotal: Int, pickedItem: [PickedItem_cart], productId: Int, cartId: Int) {
        self.id = id
        self.count = count
        self.subtotal = subtotal
        self.pickedItem = pickedItem
        self.productId = productId
        self.cartId = cartId
    }
}

extension CartItem: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CartItemCodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        count = try container.decode(Int.self, forKey: .count)
        subtotal = try container.decode(Int.self, forKey: .subtotal)
        productId = try container.decode(Int.self, forKey: .productId)
        product = try container.decode(ProductEntity.self, forKey: .product)
        cartId = try container.decode(Int.self, forKey: .cartId)
        pickedItem = try container.decode([PickedItem_cart].self, forKey: .pickedItem)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CartItemCodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(count, forKey: .count)
        try container.encode(subtotal, forKey: .subtotal)
        try container.encode(productId, forKey: .productId)
        //try container.encode(product, forKey: .product)
        try container.encode(cartId, forKey: .cartId)
        try container.encode(pickedItem, forKey: .pickedItem)
    }
}

extension CartItem: AutoEquatable {}

extension CartItem: AnimatableSectionModelType {
    
    typealias Item = PickedItem_cart
    typealias Identity = String
    
    var identity: String {
        return product?.productTypeName ?? "productTypeName"
    }
    
    var items: [PickedItem_cart] {
        return pickedItem
    }
    
    init(original: CartItem, items: [Item]) {
        self = original
        self.pickedItem = items
    }
}
