//
//  Cart.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/21.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import ObjectMapper

struct Cart: Mappable {
    var id: Int!
    var total: Int!
    var cartItems: [CartItem]!
    
    init?(map: Map) {
        
    }
    
    init(id: Int, total: Int) {
        self.id = id
        self.total = total
    }
    
    mutating func mapping(map: Map) {
        id        <- map["Id"]
        total     <- map["Total"]
        cartItems <- map["CartItems"]
    }
}
