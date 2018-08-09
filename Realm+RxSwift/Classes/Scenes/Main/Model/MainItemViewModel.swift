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
    var observable: Variable<[CasePresentable]> {get}
}

extension ProductPresentable {
    var observable: Variable<[CasePresentable]> {
        return Variable<[CasePresentable]>.init(caseModels)
    }
}

protocol CasePresentable {
    var giftboxName: String { get }
    var giftboxId: Int { get }
    var price: Int { get }
    var totalCount: Int { get }
}

class ProductModel: ProductPresentable {
    var productTypeName: String // 喜餅禮盒
    var productTypeId: Int
    var caseModels: [CasePresentable] // 鳳凰于飛 雙鳳呈祥
    
    init(_ productTypeName: String,_ productTypeId: Int,_ caseModels: [CasePresentable]) {
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
    
    init(_ giftboxName: String,_ giftboxId: Int,_ price: Int,_ totalCount: Int) {
        self.giftboxName = giftboxName
        self.giftboxId = giftboxId
        self.price = price
        self.totalCount = totalCount
    }
}

///////////////////////////////////////////////////////////

class Product {
    let product: ProductEntity
    let giftboxTypeName: String?// 鳳凰于飛
    let giftboxTypeId: Int
    let id: Int
    let name: String  // 鳳凰于飛A
    let price: Int
    let productTypeName: String  //喜餅禮盒
    let productTypeId: Int
    let items: [GiftboxItem]
    
    init(with product: ProductEntity) {
        self.product = product
        self.giftboxTypeName = product.giftboxTypeName
        self.giftboxTypeId = product.giftboxTypeId
        self.id = product.id
        self.name = product.name
        self.price = product.price
        self.productTypeName = product.productTypeName
        self.productTypeId = product.productTypeId
        self.items = Array(product.items)
    }
}

class GiftBoxViewModel {
    let giftBox: GiftboxItem
    let id: Int
    let foodCategoryName: String
    let foodCategoryId: Int
    let count: Int
    
    init(with giftBox: GiftboxItem) {
        self.giftBox = giftBox
        self.id = giftBox.id
        self.foodCategoryName = giftBox.foodCategoryName
        self.foodCategoryId = giftBox.foodCategoryId
        self.count = giftBox.count
    }
}

class FoodItemViewModel {
    let food: FoodEntity
    let id: Int
    let name: String // 巧克力腰果
    let foodCategoryId: Int
    let foodCategoryName: String
    
    init(with food: FoodEntity) {
        self.food = food
        self.id = food.id
        self.name = food.name
        self.foodCategoryId = food.foodCategoryId
        self.foodCategoryName = food.foodCategoryName
    }
}


