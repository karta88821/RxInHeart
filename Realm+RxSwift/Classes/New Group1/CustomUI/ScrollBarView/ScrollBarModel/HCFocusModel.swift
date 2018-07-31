//
//  HCFocusModel.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/4/19.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import Foundation
import ObjectMapper

struct HCFocusModel: Mappable {
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        adId <- map["adId"]
        cover <- map["cover"]
        link <- map["link"]
        realLink <- map["realLink"]
        name <- map["name"]
        
        description <- map["description"]
    }
    
    var adId = 0
    var cover = ""
    var link = ""
    var realLink = ""
    var name = ""
    
    var description = ""
}
