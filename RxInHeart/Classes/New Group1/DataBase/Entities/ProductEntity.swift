//
//  ProductEntity.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/5/29.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class ProductEntity: DBBaseBean, Mappable {
    @objc dynamic var giftboxTypeName: String? = nil // 鳳凰于飛
    @objc dynamic var giftboxTypeId: Int = 0
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = "" // 鳳凰于飛A
    @objc dynamic var price: Int = 0
    @objc dynamic var productTypeName: String = "" //喜餅禮盒
    @objc dynamic var productTypeId: Int = 0
    
    var items = List<GiftboxItem>()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func mapping(map: Map) {
        giftboxTypeName     <- map["GiftboxTypeName"]
        giftboxTypeId       <- map["GiftboxTypeId"]
        id                  <- map["Id"]
        name                <- map["Name"]
        price               <- map["Price"]
        productTypeName     <- map["ProductTypeName"]
        productTypeId       <- map["ProductTypeId"]
        items               <- (map["GiftboxItems"], ListTransform<GiftboxItem>())
    }
}

extension ProductEntity {
    var totalCount: Int {
        return Array(items).map{$0.count}.reduce(0, {$0 + $1})
    }
}

class GiftboxItem: DBBaseBean, Mappable {
    @objc dynamic var id: Int = 0
    @objc dynamic var foodCategoryName: String = "" // 典藏
    @objc dynamic var foodCategoryId: Int = 0
    @objc dynamic var count: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func mapping(map: Map) {
        id                   <- map["Id"]
        foodCategoryName     <- map["FoodCategoryName"]
        foodCategoryId       <- map["FoodCategoryId"]
        count                <- map["Count"]
    }
}
