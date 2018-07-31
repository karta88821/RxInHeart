//
//  IconItem.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/13.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import Parchment

struct IconItem: PagingItem, Hashable, Comparable {
    
    var name: String
    var index: Int
    var imageUrl: URL?
    
    init(name: String, index: Int) {
        self.name = name
        self.index = index
        self.imageUrl = URL(string: String(name).foodUrl())
    }
    
    var hashValue: Int {
        return name.hashValue
    }
    
    static func <(lhs: IconItem, rhs: IconItem) -> Bool {
        return lhs.index < rhs.index
    }
    
    static func ==(lhs: IconItem, rhs: IconItem) -> Bool {
        return (
            lhs.index == rhs.index &&
                lhs.name == rhs.name
        )
    }
}
