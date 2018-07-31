//
//  MainViewModel.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/2/13.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import RxSwift
import RxRealm
import RxCocoa
import RxFlow

struct Service {}

class MainViewModel: ServicesViewModel {
    
    var services: Service!
    //fileprivate
    fileprivate let disposeBag = DisposeBag()
    let currentId = Variable<Int>(1)
    
    // MARK: - Input
    let selectCase = PublishSubject<CaseModel>()
    
    // MARK: - Output
    let products: Observable<[ProductModel]>
    let currentGiftBoxItems: Observable<[Product]>

    init() {
        
        self.currentGiftBoxItems = selectCase.asObservable().map { cases -> [Product] in
            let giftboxId = cases.giftboxId
            let predicate = NSPredicate(format: "giftboxTypeId == \(giftboxId)")
            let sort = SortOption(propertyName: "id", isAscending: true)
            let objects = DBManager.query(ProductEntity.self, filter: predicate, sort: sort)

            let products = objects.map{Product(with: $0)}
             
            return products
        }

        
        // 喜餅禮盒：雙鳳呈祥＋鳳凰于飛
        let productResults1 = DBManager.query(ProductEntity.self,
                                              filter: NSPredicate(format: "productTypeId == 1"),
                                              sort: SortOption(propertyName: "id", isAscending: true))
        
        // 彌月禮盒
        let productResults2 = DBManager.query(ProductEntity.self,
                                              filter: NSPredicate(format: "productTypeId == 2"),
                                              sort: SortOption(propertyName: "id", isAscending: true))

        let caseModel1 = productResults1
                            .map{CaseModel($0.giftboxTypeName!,
                                           $0.giftboxTypeId,
                                           $0.price,
                                           Array($0.items).map{$0.count}.reduce(0, {$0 + $1}))}
                            .filterDuplicate{$0.giftboxId}

        let caseModel2 = productResults2
                            .map{CaseModel($0.giftboxTypeName!,
                                           $0.giftboxTypeId,
                                           $0.price,
                                           Array($0.items).map{$0.count}.reduce(0, {$0 + $1}))}
                            .filterDuplicate{$0.giftboxId}

        let productModel1 = ProductModel(productResults1.first!.productTypeName,
                                         productResults1.first!.productTypeId,
                                         caseModel1)
        let productModel2 = ProductModel(productResults2.first!.productTypeName,
                                         productResults2.first!.productTypeId,
                                         caseModel2)

        let productModelArray = [productModel1, productModel2]

        self.products = Observable.of(productModelArray)
    }
}

extension MainViewModel: Stepper {
    public func pick(compositionId: Int) {
        self.step.accept(InHeartStep.selected(compositionId: compositionId))
    }
}
