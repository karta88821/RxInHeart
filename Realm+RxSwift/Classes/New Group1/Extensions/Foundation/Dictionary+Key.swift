//
//  Dictionary+Key.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/21.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

extension Dictionary where Key == String {
    var deliveryInfo: DeliveryInfo? {
        get {
            return self["deliveryInfo"] as? DeliveryInfo
        }
        set {
            self["deliveryInfo"] = (newValue as? Value)
        }
    }
}
