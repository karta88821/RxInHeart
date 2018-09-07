//
//  InfoCell.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/25.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import SnapKit
import Reusable

class InfoCell: UITableViewCell, Reusable {
    
    // MARK : - UI
    var stackView: UIStackView!
    
    // MARK : - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView(for: contentView)
        configureCell()
        constraintUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView(for: contentView)
        configureCell()
        constraintUI()
    }

}

private extension InfoCell {
    
    func createViews() {
        configureStackView()
    }
    
    func configureView(for view: UIView) {
        createViews()
        view.backgroundColor = .white
        view.addSubview(stackView)
    }
    
    func configureStackView() {
        stackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = 5
            stack.distribution = .equalSpacing
            return stack
        }()
    }
    
    func configureCell() {
        selectionStyle = .none
    }

    func constraintUI() {
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.left.right.equalToSuperview().inset(20)
        }
    }
}
