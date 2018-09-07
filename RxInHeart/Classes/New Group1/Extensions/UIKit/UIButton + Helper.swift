//
//  UIButton + Helper.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/30.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit

extension UIButton {
    func setup(title: String?, textColor: UIColor?) {
        setTitle(title, for: .normal)
        setTitleColor(textColor, for: .normal)
    }
    
    func makeRetagle(with title: String?) {
        setup(title: title, textColor: .white)
        makeShadow(cornerRadius: 20, shadowOpacity: 0.2, shadowOffsetH: 0.3)
        clipsToBounds = true
        backgroundColor = pinkButtonBg
    }
}
