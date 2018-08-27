//
//  BaseExpandView.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/30.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import Reusable

protocol BaseExpandable: class {
    func toggleSection(header: BaseExpandableView, section: Int)
}

class BaseExpandableView: UITableViewHeaderFooterView, Reusable {
    var section: Int!
    weak var delegate: BaseExpandable?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        addExpandableGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.backgroundColor = .clear
        addExpandableGesture()
    }
    
    @objc func selectHeaderAction(gestureRecognizer: UITapGestureRecognizer) {
        let cell = gestureRecognizer.view as! BaseExpandableView
        delegate?.toggleSection(header: self, section: cell.section)
    }
    
    private func addExpandableGesture() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderAction)))
    }
}
