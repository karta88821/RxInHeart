//
//  UIButton+Animation.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/8/20.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit

extension UIButton {
    func dim() {
        UIView.animate(withDuration: 0.15, animations: {
            self.alpha = 0.75
        }) { (finished) in
            UIView.animate(withDuration: 0.15, animations: {
                self.alpha = 1.0
            })
        }
    }
}
