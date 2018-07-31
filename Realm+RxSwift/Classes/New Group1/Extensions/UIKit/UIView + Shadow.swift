//
//  UIView + Shadow.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/30.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit

extension UIView {
    func makeShadow(cornerRadius: CGFloat = 0, shadowOpacity: Float = 0.5, shadowOffsetW: CGFloat = 0, shadowOffsetH: CGFloat = 0.5) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.cornerRadius = cornerRadius
        layer.shadowOffset = CGSize(width: shadowOffsetW, height: shadowOffsetH)
        layer.shadowOpacity = shadowOpacity
    }
    
    func makeCircle() {
        clipsToBounds = true
        layer.cornerRadius = bounds.size.width / 2
    }
    
    func makeBorder(width: CGFloat, color: UIColor = .black) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
}
