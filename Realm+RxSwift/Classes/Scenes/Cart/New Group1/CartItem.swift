//
//  CartItem.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/21.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import ObjectMapper
import RxDataSources
import AutoEquatable
import RxDataSources
import Foundation
import AutoEquatable

struct CartItem: Mappable {
    fileprivate var id: Int!
    fileprivate var count: Int!
    fileprivate var subtotal: Int!
    fileprivate var pickedItem: [PickedItem_cart]!
    fileprivate var productId: Int!
    fileprivate var product: Product_cart!
    fileprivate var cartId: Int!
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

extension CartItem: AutoEquatable {}

extension CartItem {
    func getId() -> Int { return id }
    func getCount() -> Int { return count }
    func getSubtotal() -> Int { return subtotal }
    func getPickItems() -> [PickedItem_cart] { return pickedItem }
    func getProductId() -> Int { return productId }
    func getProduct() -> Product_cart { return product }
    func getCartId() -> Int { return cartId }
}

extension CartItem: AnimatableSectionModelType {
    
    typealias Item = PickedItem_cart
    typealias Identity = String
    
    var identity: String {
        return getProduct().getProductTypeName()
    }
    
    var items: [PickedItem_cart] {
        return pickedItem
    }
    
    init(original: CartItem, items: [Item]) {
        self = original
        self.pickedItem = items
    }
}




