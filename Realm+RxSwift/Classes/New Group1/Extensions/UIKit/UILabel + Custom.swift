//
//  UILabel + Custom.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/30.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit

extension UILabel {
//    func setup(textAlignment: NSTextAlignment = .center,
//               fontSize: CGFloat = 16,
//               textColor: UIColor? = .black) {
//        self.textAlignment = textAlignment
//        self.font = UIFont.systemFont(ofSize: fontSize)
//        self.textColor = textColor
//    }
//    
//    func setupWithTitle(textAlignment: NSTextAlignment = .center,
//                        fontSize: CGFloat = 16,
//                        textColor: UIColor? = .black,
//                        text: String? ) {
//        self.textAlignment = textAlignment
//        self.font = UIFont.systemFont(ofSize: fontSize)
//        self.textColor = textColor
//        self.text = text
//    }
    
    convenience init(alignment: NSTextAlignment = .center,
                     fontSize: CGFloat = 16,
                     textColor: UIColor? = grayColor,
                     text: String? = nil) {
        self.init()
        self.textAlignment = alignment
        self.font = UIFont.systemFont(ofSize: fontSize)
        self.textColor = textColor
        self.text = text
    }
}
