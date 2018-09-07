//
//  ExtensionMethod.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/3/19.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import Foundation


/// 資料庫的名字
///
/// - db: db
public enum dataBaseName: String {
    case db = "db"
}

/// 在run debug的狀態打印所需要的信息
///
/// - Parameter items: 所要打印的内容
public func mPrint(_ items: Any...) {
    #if DEBUG
        debugPrint(items)
    #endif
}
