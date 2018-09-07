//
//  DBBaseBean.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/5/30.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import RealmSwift

class DBBaseBean: Object {
    override class func ignoredProperties() -> [String] {
        return []
    }
}
