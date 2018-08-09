//
//  ProductCart.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/21.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import ObjectMapper
import AutoEquatable

struct Product_cart: Mappable {
    private var giftboxTypeName: String?
    private var giftboxTypeId: Int!
    private var id: Int!
    private var name: String!
    private var price: Int!
    private var productTypeName: String!
    private var productTypeId: Int!
    private var giftboxItems: [GiftboxItem_cart]!
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        giftboxTypeName     <- map["GiftboxTypeName"]
        giftboxTypeId       <- map["GiftboxTypeId"]
        id                  <- map["Id"]
        name                <- map["Name"]
        price               <- map["Price"]
        productTypeName     <- map["ProductTypeName"]
        productTypeId       <- map["ProductTypeId"]
        giftboxItems        <- map["GiftboxItems"]
    }
}

extension Product_cart {
    func getGiftboxTypeName() -> String { return giftboxTypeName ?? "這不是禮盒" }
    func getGiftboxTypeId() -> Int { return giftboxTypeId }
    func getId() -> Int { return id }
    func getName() -> String { return name }
    func getPrice() -> Int { return price }
    func getProductTypeName() -> String { return productTypeName }
    func getProductTypeId() -> Int { return giftboxTypeId }
    func getGiftboxItems() -> [GiftboxItem_cart] { return giftboxItems }
}

extension Product_cart: AutoEquatable {}
