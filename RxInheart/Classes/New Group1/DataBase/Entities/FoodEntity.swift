//
//  FoodEntity.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/5/29.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class FoodEntity: DBBaseBean, Mappable {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = "" // 巧克力腰果
    @objc dynamic var foodCategoryId: Int = 0
    @objc dynamic var foodCategoryName: String = "" // 小餅乾
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func mapping(map: Map) {
        id              <- map["Id"]
        name            <- map["Name"]
        foodCategoryId  <- map["FoodCategoryId"]
        foodCategoryName  <- map["FoodCategoryName"]
    }
}
