//
//  CartItem.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/21.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import ObjectMapper
import RxDataSources

struct CartItem: Mappable {
    var id: Int!
    var count: Int!
    var subtotal: Int!
    var pickedItem: [PickedItem_cart]!
    var productId: Int!
    var product: Product_cart!
    var cartId: Int!
    var expanded: Bool = false
    
    init?(map: Map) {
        
    }
    
    init(id: Int, count: Int, subtotal: Int, pickedItem: [PickedItem_cart], productId: Int, cartId: Int) {
        self.id = id
        self.count = count
        self.subtotal = subtotal
        self.pickedItem = pickedItem
        self.productId = productId
        self.cartId = cartId
    }
    
    mutating func mapping(map: Map) {
        id           <- map["Id"]
        count        <- map["Count"]
        subtotal     <- map["SubTotal"]
        pickedItem   <- map["PickedItem"]
        productId    <- map["ProductId"]
        product      <- map["Product"]
        cartId       <- map["CartId"]
        
    }
}

extension CartItem: Equatable {}

func == (lhs: CartItem, rhs: CartItem) -> Bool {
    return lhs.id == rhs.id &&
        lhs.count == rhs.count &&
        lhs.subtotal == rhs.subtotal &&
        lhs.pickedItem == rhs.pickedItem &&
        lhs.productId == rhs.productId &&
        lhs.product == rhs.product &&
        lhs.cartId == rhs.cartId &&
        lhs.expanded == rhs.expanded
}

