//
//  PaymentCell.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/2.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import SnapKit
import SkyFloatingLabelTextField
import RxSwift
import RxCocoa
import Reusable

let paymentH: CGFloat = 60.0

class PaymentCell: UITableViewCell, Reusable {
    
    // MARK : - UI
    let topView = UIView()
    let bottomView = UIView()
    let nameField = SkyFloatingLabelTextField(frame: .zero)
    let phoneField = SkyFloatingLabelTextField(frame: .zero)
    let emailField = SkyFloatingLabelTextField(frame: .zero)
    
    private(set) var disposeBag = DisposeBag()
    
    // MARK : - Initialization
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
        constraintUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initUI()
        constraintUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

}

private extension PaymentCell {
    func initUI() {
        selectionStyle = .none
        
        topView.backgroundColor = .white
        bottomView.backgroundColor = .white
        nameField.configure(with: "付款人姓名")
        phoneField.configure(with: "付款人聯絡電話")
        emailField.configure(with: "付款人信箱")
        contentView.addSubViews(views: topView, bottomView)
        topView.addSubViews(views: nameField, phoneField)
        bottomView.addSubview(emailField)
    }
    
    func constraintUI() {
        
        topView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(paymentH)
        }
        
        bottomView.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.top.equalTo(topView.snp.bottom)
        }
        
        nameField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(25)
            $0.width.equalTo(150)
        }
        
        phoneField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-25)
            $0.width.equalTo(150)
        }
        
        emailField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.right.equalToSuperview().inset(25)
        }
    }
}

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
