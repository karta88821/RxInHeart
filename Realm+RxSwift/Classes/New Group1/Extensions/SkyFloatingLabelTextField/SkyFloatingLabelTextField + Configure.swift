//
//  SkyFloatingLabelTextField + Configure.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/9/2.
//  Copyright © 2018 liao yuhao. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

extension SkyFloatingLabelTextField {
    func configure(with title: String?,placeholderFont: CGFloat = 18) {
        self.title = title
        self.placeholder = title
        self.titleFont = UIFont.systemFont(ofSize: 15)
        self.placeholderFont = UIFont.systemFont(ofSize: placeholderFont)
        self.lineColor = grayColor!
        self.selectedTitleColor = textFieldTitleColor!
        self.selectedLineColor = textFieldTitleColor!
    }
}
