//
//  CartItemSection.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/14.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import RxDataSources
import Foundation

extension CartItem: AnimatableSectionModelType {
    
    typealias Item = PickedItem_cart
    typealias Identity = String
    
    var identity: String {
        return product.productTypeName
    }
    
    var items: [PickedItem_cart] {
        return pickedItem
    }
    
    init(original: CartItem, items: [Item]) {
        self = original
        self.pickedItem = items
    }
}

extension PickedItem_cart
    : IdentifiableType
, Equatable {
    typealias Identity = Int
    
    var identity: Int {
        return id
    }
}

