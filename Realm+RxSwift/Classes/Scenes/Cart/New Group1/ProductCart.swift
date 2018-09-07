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
    var giftboxTypeName: String?
    var giftboxTypeId: Int!
    var id: Int!
    var name: String!
    var price: Int!
    var productTypeName: String!
    var productTypeId: Int!
    var giftboxItems: [GiftboxItem_cart]!
    
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

extension Product_cart: AutoEquatable {}
