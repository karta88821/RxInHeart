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
    var topView: UIView!
    var bottomView: UIView!
    var nameField: SkyFloatingLabelTextField!
    var phoneField: SkyFloatingLabelTextField!
    var emailField: SkyFloatingLabelTextField!
    
    // MARK : - Property
    private(set) var disposeBag = DisposeBag()
    
    // MARK : - Initialization
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

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

}

private extension PaymentCell {
    
    func createViews() {
        configureTopAndBottomView()
        configureTextFields()
    }
    
    func configureView(for view: UIView) {
        createViews()
        view.addSubViews(views: topView, bottomView)
        topView.addSubViews(views: nameField, phoneField)
        bottomView.addSubview(emailField)
    }
    
    func configureCell() {
        selectionStyle = .none
    }
    
    func configureTopAndBottomView() {
        topView = UIView(backgroundColor: .white)
        bottomView = UIView(backgroundColor: .white)
    }
    
    func configureTextFields() {
        nameField = {
            let textField = SkyFloatingLabelTextField()
            textField.configure(with: "付款人姓名")
            return textField
        }()
        
        phoneField = {
            let textField = SkyFloatingLabelTextField()
            textField.configure(with: "付款人聯絡電話")
            return textField
        }()
        
        emailField = {
            let textField = SkyFloatingLabelTextField()
            textField.configure(with: "付款人信箱")
            return textField
        }()
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
