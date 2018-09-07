//
//  FormSectionViewModel.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/30.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import RxDataSources
import RxSwift
import AutoEquatable

enum FormMutipleSectionModel {
    case DeliverySection(title: String, items: [FormSectionItem])
    case PaymentSection(title: String, items: [FormSectionItem])
    case CheckSection(title: String, items: [FormSectionItem])
}

enum FormSectionItem {
    case deliberySectionItem(deliveryInfo: DeliveryInfo)
    case paymentSectionItem
    case checkSectionItem
}

extension FormMutipleSectionModel: AnimatableSectionModelType {
    
    typealias Item = FormSectionItem
    typealias Identity = String
    
    var identity: String {
        switch self {
        case .DeliverySection(let title, _):
            return title
        case .PaymentSection(let title, _):
            return title
        case .CheckSection(let title, _):
            return title
        }
    }
    
    var items: [FormSectionItem] {
        switch self {
        case .DeliverySection(title: _, items: let items):
            return items.map{$0}
        case .PaymentSection(title: _, items: let items):
            return items.map{$0}
        case .CheckSection(title: _, items: let items):
            return items.map{$0}
        }
    }
    
    init(original: FormMutipleSectionModel, items: [FormSectionItem]) {
        switch original {
        case let .DeliverySection(title,_):
            self = .DeliverySection(title: title, items: items)
        case let .PaymentSection(title,_):
            self = .PaymentSection(title: title, items: items)
        case let .CheckSection(title,_):
            self = .CheckSection(title: title, items: items)
        }
    }
}

extension FormSectionItem: IdentifiableType, AutoEquatable {
    typealias Identity = String
    
    var identity: String {
        switch self {
        case .deliberySectionItem(let deliveryInfo):
            return deliveryInfo.address
        case .paymentSectionItem:
            return ""
        case .checkSectionItem:
            return ""
        }
    }
    
}

extension FormMutipleSectionModel: AutoEquatable {}
