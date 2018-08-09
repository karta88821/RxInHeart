//
//  IconTextField.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/8/6.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class IconTextField: SkyFloatingLabelTextField {
    
    var iconImageView: UIImageView!
    
    var icon: UIImage? = UIImage(named: "giftcard") {
        didSet {
            updateImageView()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createIcon()
    }
    
    func createIcon() {
        let imageView = UIImageView(frame: CGRect(x: bounds.origin.x,
                                                  y: 0,
                                                  width: 30,
                                                  height: 30))
        imageView.contentMode = .scaleToFill
        addSubview(imageView)
        self.iconImageView = imageView
    }
    
    func updateImageView() {
        if let icon = icon {
            iconImageView.image = icon
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func titleLabelRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
        let iconWidth = iconImageView.bounds.width
        if editing {
            return CGRect(x: iconWidth, y: 0, width: bounds.size.width, height: titleHeight())
        }
        return CGRect(x: iconWidth, y: titleHeight(), width: bounds.size.width, height: titleHeight())
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let rect = CGRect(
            x: iconImageView.bounds.width,
            y: titleHeight(),
            width: bounds.size.width,
            height: bounds.size.height - titleHeight() - selectedLineHeight
        )
        return rect
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.editingRect(forBounds: bounds)
        let titleHeight = self.titleHeight()
        let iconWidth = iconImageView.bounds.width
        
        let rect = CGRect(x: superRect.origin.x + iconWidth,
                          y: titleHeight,
                          width: superRect.size.width,
                          height: superRect.size.height - titleHeight - selectedLineHeight)
        
        return rect
    }
}
