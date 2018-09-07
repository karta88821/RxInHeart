//
//  DeliveryInfo.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/7.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import Foundation
import AutoEquatable

struct DeliveryInfo {
    var name: String
    var phone: String
    var address: String
    var deliveryInfoCartItems: [DeliveryInfoCartItem]
}

extension DeliveryInfo: AutoEquatable {}
