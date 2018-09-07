//
//  Array+Extensions.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/5/31.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import Foundation

extension Array
{
    func filterDuplicate<T>(_ keyValue:(Element)->T) -> [Element]
    {
        var uniqueKeys = Set<String>()
        return filter{uniqueKeys.insert("\(keyValue($0))").inserted}
    }
}
