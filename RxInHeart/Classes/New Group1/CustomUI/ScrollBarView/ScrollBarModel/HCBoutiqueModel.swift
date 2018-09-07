//
//  HCBoutiqueModel.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/4/19.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//
import Foundation
import ObjectMapper

struct HCBoutiqueModel: Mappable {
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        ret <- map["ret"]
        hasRecommendedZones <- map["hasRecommendedZones"]
        msg <- map["msg"]
        serverMilliseconds <- map["serverMilliseconds"]
        
        focusList <- map["focusImages.data"]
    }
    
    var ret = 0
    var hasRecommendedZones = false
    var msg = "成功"
    var serverMilliseconds: UInt32 = 0
    
    var focusList: [HCFocusModel]?

}
