//
//  SectionType.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/21.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import Foundation

enum VcTypes {
    case infoDetail
}

enum SectionTypes {
    case deliveryInfo, allocateInfo
}

extension VcTypes {
    func getSectionTypes() -> [SectionTypes] {
        switch self {
        case .infoDetail:
            return [.deliveryInfo, .allocateInfo]
        }
    }
}


