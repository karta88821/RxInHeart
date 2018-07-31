//
//  UIViewController+HideKeyboard.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/12.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
