//
//  AddressViewController.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/4.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import SnapKit
import SkyFloatingLabelTextField
import RxSwift
import RxCocoa

class AddressViewController: UIViewController {
    
    // MARK : ViewModel
    var viewModel: AddressViewModel!
    
    // MARK : UI
    let topView = BaseTopView()
    
    let nameField = SkyFloatingLabelTextField(frame: .zero)
    let phoneField = SkyFloatingLabelTextField(frame: .zero)
    let addressField = SkyFloatingLabelTextField(frame: .zero)
    let button = UIButton()

    // MARK : View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        constraintUI()
        bindUI()
        hideKeyboard()
    }

}

private extension AddressViewController {
    
    func initUI() {

        topView.highlightedPosition = .left
        
        nameField.configure(with: "收貨人姓名", placeholderFont: 20)
        phoneField.configure(with: "收貨人聯絡電話", placeholderFont: 20)
        addressField.configure(with: "收貨人地址", placeholderFont: 20)

        button.makeRetagle(with: "選擇宅配數量")
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    
        view.addSubViews(views: topView, nameField, button, phoneField, addressField)
        view.backgroundColor = .white
    }
    
    func constraintUI() {
        topView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(80)
        }
        
        nameField.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(50)
            $0.left.equalTo(addressMargin)
            $0.width.equalTo(120)
        }
        phoneField.snp.makeConstraints {
            $0.top.equalTo(nameField.snp.bottom).offset(30)
            $0.left.right.equalToSuperview().inset(addressMargin)
        }
        addressField.snp.makeConstraints {
            $0.top.equalTo(phoneField.snp.bottom).offset(30)
            $0.left.right.equalToSuperview().inset(addressMargin)
        }
        
        button.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-30)
            $0.width.equalTo(180)
            $0.height.equalTo(40)
        }
    }
    
    func bindUI() {
        let nameValidation = nameField.rx.text.orEmpty.map{!$0.isEmpty}.share(replay: 1)
        let phoneValidation = phoneField.rx.text.orEmpty.map{!$0.isEmpty}.share(replay: 1)
        let addressValidation = addressField.rx.text.orEmpty.map{!$0.isEmpty}.share(replay: 1)
        
        let enableButton = Observable.combineLatest(nameValidation, phoneValidation, addressValidation) { (name, phone, address) in
            return name && phone && address
        }
        
        enableButton.bind(to: button.rx.isEnabled).disposed(by: rx.disposeBag)
    }
    
    @objc func buttonAction(_ sender: AnyObject) {
        guard let nameText = nameField.text, let phoneText = phoneField.text, let addressText = addressField.text else {
            return
        }
        let deliveryInfo = DeliveryInfo(name: nameText, phone: phoneText, address: addressText)
        viewModel.goAllocate(deliveryInfo: deliveryInfo)
    }
}
