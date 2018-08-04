//
//  UIViewController+Tabbar.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/8/2.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit

extension UIViewController {
    var tabBarHight: CGFloat {
        return self.tabBarController?.tabBar.frame.height ?? 0
    }

}
