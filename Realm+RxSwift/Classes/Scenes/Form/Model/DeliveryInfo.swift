//
//  DeliveryInfo.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/7.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import Foundation

class DeliveryInfo: NSObject {
    var name: String
    var phone: String
    var address: String
    var deliveryInfoCartItems: [DeliveryInfoCartItem]
    
    init(name: String, phone: String, address: String) {
        self.name = name
        self.phone = phone
        self.address = address
        self.deliveryInfoCartItems = [DeliveryInfoCartItem]()
    }
}
