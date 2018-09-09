//
//  FoodEntity.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/5/29.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import Realm
import RealmSwift
import Moya

class FoodEntity: DBBaseBean, Codable {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = "" // 巧克力腰果
    @objc dynamic var foodCategoryId: Int = 0
    @objc dynamic var foodCategoryName: String = "" // 小餅乾
    
    override class func primaryKey() -> String? {
        return "id"
    }

    private enum FoodCodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case foodCategoryId = "FoodCategoryId"
        case foodCategoryName = "FoodCategoryName"
    }
    
    convenience init(id: Int, name: String, foodCategoryId: Int, foodCategoryName: String) {
        self.init()
        self.id = id
        self.name = name
        self.foodCategoryId = foodCategoryId
        self.foodCategoryName = foodCategoryName
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: FoodCodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let foodCategoryId = try container.decode(Int.self, forKey: .foodCategoryId)
        let foodCategoryName = try container.decode(String.self, forKey: .foodCategoryName)
        self.init(id: id, name: name, foodCategoryId: foodCategoryId, foodCategoryName: foodCategoryName)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: FoodCodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(foodCategoryId, forKey: .foodCategoryId)
        try container.encode(foodCategoryName, forKey: .foodCategoryName)
    }
    
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
}
