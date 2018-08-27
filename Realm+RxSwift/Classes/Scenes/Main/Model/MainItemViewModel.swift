//
//  MainItemViewModel.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/3/17.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import RxSwift

protocol ProductPresentable {
    var productTypeName: String { get }
    var productTypeId: Int { get }
    var caseModels: [CasePresentable] { get }
}

protocol CasePresentable {
    var products: [ProductEntity]? {get}
    var giftboxName: String { get }
    var giftboxId: Int { get }
    var price: Int { get }
    var totalCount: Int { get }
}

class ProductModel: ProductPresentable {
    var productTypeName: String // 喜餅禮盒
    var productTypeId: Int
    var caseModels: [CasePresentable] // 鳳凰于飛 雙鳳呈祥
    
    init(_ productTypeName: String,_ productTypeId: Int
        ,_ caseModels: [CasePresentable]) {
        self.productTypeName = productTypeName
        self.productTypeId = productTypeId
        self.caseModels = caseModels
    }
}

class CaseModel: CasePresentable {
    var giftboxName: String //鳳凰于飛 雙鳳呈祥
    var giftboxId: Int
    var price: Int // 100元
    var totalCount: Int
    
    var products: [ProductEntity]?
    
    init(_ giftboxName: String,_ giftboxId: Int,_ price: Int,_ totalCount: Int, products: [ProductEntity]? = nil) {
        self.giftboxName = giftboxName
        self.giftboxId = giftboxId
        self.price = price
        self.totalCount = totalCount
        self.products = products
    }
}
