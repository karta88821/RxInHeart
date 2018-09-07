//
//  String+Extensions.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/1.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import Foundation

extension String {
    
    func giftBoxUrl() -> String {
        return "http://163.18.22.78:1003/Images/giftboxType_\(self).jpg"
    }
    
    // food的id Ex:巧克力餅乾
    func foodUrl() -> String {
        return "http://163.18.22.78:1003/Images/food_\(self).png"
    }
    
}
