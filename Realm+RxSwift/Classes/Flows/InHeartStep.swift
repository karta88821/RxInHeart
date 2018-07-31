//
//  InHeartStep.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/3/1.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import RxFlow

enum InHeartStep: Step {
    
    case firstScreen
    
    case mainSelected
    case selected(compositionId: Int)
    case selectedDone
    
    case account
    case shoppingNote
    
    case dismissCart
    case cart
    
    case productList // 購物車裡的商品列表
    case form // 選擇付款/運送方式
    case address // 新增一個地址
    case allocateProduct(deliveryItem: DeliveryInfo)
    case dismissAddress
    case infoDetail
    case dismissInfo
    case sendOrder(sendModel: SendOrderModel)
    case orderDetail(sendModel: SendOrderModel)
}
