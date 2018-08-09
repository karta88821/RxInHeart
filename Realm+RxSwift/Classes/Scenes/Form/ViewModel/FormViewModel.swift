//
//  FormViewModel.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/1.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa
import RxDataSources

protocol InfoEditable: class {
    func insertInfo(info: DeliveryInfo)
    func deleteInfo(at row: Int)
}

class FormViewModel {
    
    private let disposeBag = DisposeBag()

    var dataSource = RxTableViewSectionedAnimatedDataSource<FormMutipleSectionModel>(configureCell: {(_,_,_,_) in
        fatalError()
    })
    
    let sections = Variable<[FormMutipleSectionModel]>([])
    
    let cartItems = Variable<[CartItem]>([])
    let totalPrice = Variable<Int>(0)

    init(service: APIDelegate = APIClient.sharedAPI) {
        
        infoManager.infoList.asObservable()
            .map { infoList -> [FormMutipleSectionModel] in
                
            let delivery: FormMutipleSectionModel =
                            .DeliverySection(title: "運送方式",
                                             items: infoList.map{.deliberySectionItem(deliveryInfo: $0)})
            let payment: FormMutipleSectionModel =
                            .PaymentSection(title: "付款方式", items: [.paymentSectionItem])
            let check: FormMutipleSectionModel =
                            .CheckSection(title: "已閱讀“運送方式說明”及“付款方式說明”", items: [])
                
            return [delivery, payment, check]
                    
            }
            .bind(to: sections)
            .disposed(by: disposeBag)
        
        service.getCartItems()
            .bind(to: cartItems)
            .disposed(by: disposeBag)

        service.getCartItems()
            .map { items -> Int in
                return items.map{$0.getSubtotal()}.reduce(0,{ $0 + $1})
            }
            .bind(to: totalPrice)
            .disposed(by: disposeBag)
    }
}

extension FormViewModel: InfoEditable {
    func insertInfo(info: DeliveryInfo) {
        infoManager.insert(with: info)
    }
    func deleteInfo(at row: Int) {
        infoManager.remove(at: row)
    }
}

extension FormViewModel: Stepper {
    public func goSendOrder(with sendModel: SendOrderModel) {
        self.step.accept(InHeartStep.sendOrder(sendModel: sendModel))
    }
    @objc func goAddress() {
        self.step.accept(InHeartStep.address)
    }
    @objc func goInfoDetail() {
        self.step.accept(InHeartStep.infoDetail)
    }
}
