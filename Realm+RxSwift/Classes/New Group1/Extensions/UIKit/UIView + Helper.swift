//
//  UIView + Helper.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/30.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit

extension UIView {
    func addSubViews(views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
