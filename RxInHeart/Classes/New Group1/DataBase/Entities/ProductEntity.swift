//
//  ProductEntity.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/5/29.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//
import Foundation
import RealmSwift
import Realm

class ProductEntity: DBBaseBean, Codable {
    @objc dynamic var giftboxTypeName: String? = nil // 鳳凰于飛
    @objc dynamic var giftboxTypeId: Int = 0
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = "" // 鳳凰于飛A
    @objc dynamic var price: Int = 0
    @objc dynamic var productTypeName: String = "" //喜餅禮盒
    @objc dynamic var productTypeId: Int = 0
    
    var items = List<GiftboxItem>()

    override class func primaryKey() -> String? {
        return "id"
    }
    
    private enum ProductCodingKeys: String, CodingKey {
        case giftboxTypeName = "GiftboxTypeName"
        case giftboxTypeId = "GiftboxTypeId"
        case id = "Id"
        case name = "Name"
        case price = "Price"
        case productTypeName = "ProductTypeName"
        case productTypeId = "ProductTypeId"
        case items = "GiftboxItems"
    }
    
    convenience init(giftboxTypeName: String?, giftboxTypeId: Int, id: Int, name: String, price: Int, productTypeName: String, productTypeId: Int, items: List<GiftboxItem>) {
        self.init()
        self.giftboxTypeName = giftboxTypeName
        self.giftboxTypeId = giftboxTypeId
        self.id = id
        self.name = name
        self.price = price
        self.productTypeName = productTypeName
        self.productTypeId = productTypeId
        self.items = items
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ProductCodingKeys.self)
        let giftboxTypeName = try container.decode(String.self, forKey: .giftboxTypeName)
        let giftboxTypeId = try container.decode(Int.self, forKey: .giftboxTypeId)
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let price = try container.decode(Int.self, forKey: .price)
        let productTypeName = try container.decode(String.self, forKey: .productTypeName)
        let productTypeId = try container.decode(Int.self, forKey: .productTypeId)
        let itemArray = try container.decode([GiftboxItem].self, forKey: .items)
        let itemList = List<GiftboxItem>()
        itemList.append(objectsIn: itemArray)
        self.init(giftboxTypeName: giftboxTypeName, giftboxTypeId: giftboxTypeId, id: id, name: name, price: price, productTypeName: productTypeName, productTypeId: productTypeId, items: itemList)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ProductCodingKeys.self)
        try container.encode(giftboxTypeName, forKey: .giftboxTypeName)
        try container.encode(giftboxTypeId, forKey: .giftboxTypeId)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(price, forKey: .price)
        try container.encode(productTypeName, forKey: .productTypeName)
        try container.encode(productTypeId, forKey: .productTypeId)
        try container.encode(Array(items), forKey: .items)
    }
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}

extension ProductEntity {
    var totalCount: Int {
        return Array(items).map{$0.count}.reduce(0, {$0 + $1})
    }
}

private enum GiftboxItemCodingKeys: String, CodingKey {
    case id = "Id"
    case foodCategoryName = "FoodCategoryName"
    case foodCategoryId = "FoodCategoryId"
    case count = "Count"
}

class GiftboxItem: DBBaseBean, Codable {
    @objc dynamic var id: Int = 0
    @objc dynamic var foodCategoryName: String = "" // 典藏
    @objc dynamic var foodCategoryId: Int = 0
    @objc dynamic var count: Int = 0
    
    override class func primaryKey() -> String? {
        return "id"
    }

    convenience init(id: Int, foodCategoryName: String, foodCategoryId: Int, count: Int) {
        self.init()
        self.id = id
        self.foodCategoryName = foodCategoryName
        self.foodCategoryId = foodCategoryId
        self.count = count
    }
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: GiftboxItemCodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let foodCategoryName = try container.decode(String.self, forKey: .foodCategoryName)
        let foodCategoryId = try container.decode(Int.self, forKey: .foodCategoryId)
        let count = try container.decode(Int.self, forKey: .count)
        self.init(id: id, foodCategoryName: foodCategoryName, foodCategoryId: foodCategoryId, count: count)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: GiftboxItemCodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(foodCategoryName, forKey: .foodCategoryName)
        try container.encode(foodCategoryId, forKey: .foodCategoryId)
        try container.encode(count, forKey: .count)
    }
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}
