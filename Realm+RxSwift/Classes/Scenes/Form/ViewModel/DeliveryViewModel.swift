//
//  DeliveryViewModel.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/30.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import Foundation

class DeliveryViewModel: RowViewModel {
    private let index: Int
    private let deliveryInfo: DeliveryInfo
    
    init(index: Int, deliveryInfo: DeliveryInfo) {
        self.index = index
        self.deliveryInfo = deliveryInfo
    }
    
    func getIndex() -> Int {
        return index
    }
    
    func getAddress() -> String {
        return deliveryInfo.address
    }
}
