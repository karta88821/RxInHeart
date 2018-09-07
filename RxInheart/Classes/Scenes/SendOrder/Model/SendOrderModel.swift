//
//  SendOrderModel.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/23.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit

struct SendOrderModel {
    var cartItems: [CartItem]
    var totalPrice: Int
    let deliveryState: DeliveryState
    let paymentState: PaymentState
    let paymentInfo: PaymentInfo
    let orderInfo: OrderInfo
}

struct PaymentInfo {
    let name: String
    let phoneNumber: String
    let email: String
}

struct OrderInfo {
    let deliveryType: DeliveryState
    let paymentType: PaymentState
    var payStatus: PayStatus
    let businessInfo: BusinessInfo
}

enum PayStatus: String {
    case notyet = "未付款"
    case success = "已付款"
    
    func textColor() -> UIColor? {
        switch self {
        case .notyet:
            return darkRed
        case .success:
            return .green
        }
    }
}



struct BusinessInfo {
    let id: Int
    let name: String
}

let businessA = BusinessInfo(id: 1, name: "豪豪")

