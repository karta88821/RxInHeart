//
//  SectionType.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/21.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import Foundation

enum VcTypes {
    case payment
    case infoDetail
}

enum SectionTypes {
    case delivery, payment, check
    case deliveryInfo, allocateInfo

}

extension VcTypes {
    func getSectionTypes() -> [SectionTypes] {
        switch self {
        case .payment:
            return [.delivery, .payment, .check]
        case .infoDetail:
            return [.deliveryInfo, .allocateInfo]
        }
    }
}

func getSection(source sections: [SectionTypes], for section: Int) -> SectionTypes {
    return sections[section]
}

