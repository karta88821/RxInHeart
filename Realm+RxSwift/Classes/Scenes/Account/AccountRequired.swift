//
//  AccountRequired.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/8/9.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import Foundation

protocol AccountRequired { }

extension AccountRequired {
    var titles: [String] {
        return ["會員資料","訂單查詢","線上諮詢"]
    }
}
