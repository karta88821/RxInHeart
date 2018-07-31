//
//  PopViewPresentable.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/28.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit

protocol PopViewPresentable {
    func showPopup(item: CartItem?, deliveryInfo: DeliveryInfo?)
}

//extension PopViewPresentable {
//    func showCartItem(item: CartItem) { }
//    func showDeliveryItems(deliveryInfo: DeliveryInfo) { }
//}
