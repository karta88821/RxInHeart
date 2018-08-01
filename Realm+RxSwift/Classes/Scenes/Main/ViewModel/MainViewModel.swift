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
import RealmSwift

class MainViewModel {
    
    var service: APIDelegate!
    
    let `$`: Dependencies = Dependencies.sharedDependencies
    
    private let disposeBag = DisposeBag()
    
    let currentId = Variable<Int>(1)
    let databaseIsEmpty = Variable<Bool>(true)
    
    // MARK: - Input
    let selectCase = PublishSubject<CaseModel>()
    
    // MARK: - Output
    let products = Variable<[ProductModel]>([])
    let currentGiftBoxItems: Observable<[Product]>

    init(service: APIDelegate = APIClient.sharedAPI) {
        
        self.service = service
        
        self.currentGiftBoxItems = selectCase.asObservable().map { cases -> [Product] in
            let giftboxId = cases.giftboxId
            let predicate = NSPredicate(format: "giftboxTypeId == \(giftboxId)")
            let sort = SortOption(propertyName: "id", isAscending: true)
            let objects = DBManager.query(ProductEntity.self, filter: predicate, sort: sort)

            let products = objects.map{Product(with: $0)}
             
            return products
        }
    }
    
    func start() {
        DBManager.isEmpty()
            .subscribeOn(`$`.backgroundWorkScheduler)
            .observeOn(`$`.mainScheduler)
            .subscribe(onNext:{ [weak self] bool in
            switch bool {
            case true:
                sleep(3)
                self?.setupDatabase()
                self?.databaseIsEmpty.value = false
            case false:
                sleep(3)
                let productResults = DBManager.query(ProductEntity.self,
                                                     sort: SortOption(propertyName: "id", isAscending: true))
                self?.products.value = (self?.setupModel(with: productResults))!
                self?.databaseIsEmpty.value = false
            }
        })
        .disposed(by: disposeBag)
    }
    
    func setupDatabase() {
        service.getFoods().subscribe(onNext:{ response in
            DBManager.write(response)
        },onError:{ error in
            print("數據請求失敗!錯誤原因：", error)
        })
        .disposed(by: disposeBag)
        
        service.getProducts().subscribe(onNext:{ [weak self] response in
            self?.products.value = (self?.setupModel(with: response))!
            DBManager.write(response)
        },onError:{ error in
            print("數據請求失敗!錯誤原因：", error)
        })
        .disposed(by: self.disposeBag)
    }

    func setupModel(with products: [ProductEntity]) -> [ProductModel]{
        var productArray: [[ProductEntity]] = [[],[],[]] // 喜餅禮盒：雙鳳呈祥＋鳳凰于飛 // 彌月禮盒 // 婚禮小物

        products.forEach { results in
            switch results.productTypeId {
            case 1:
                productArray[0].append(results)
            case 2:
                productArray[1].append(results)
            case 3:
                productArray[2].append(results)
            default: break
            }
        }


        let caseModel1 = productArray[0]
                            .map{CaseModel($0.giftboxTypeName!,
                                           $0.giftboxTypeId,
                                           $0.price,
                                           Array($0.items).map{$0.count}.reduce(0, {$0 + $1}))}
                            .filterDuplicate{$0.giftboxId}
        
        
        let caseModel2 = productArray[1]
                            .map{CaseModel($0.giftboxTypeName!,
                                           $0.giftboxTypeId,
                                           $0.price,
                                           Array($0.items).map{$0.count}.reduce(0, {$0 + $1}))}
                            .filterDuplicate{$0.giftboxId}
        
        let caseModel3 = productArray[2].map{CaseModel($0.name, $0.giftboxTypeId, $0.price, 1) }
        

        guard let productModel1First = productArray[0].first,
            let productModel2First = productArray[1].first,
            let productModel3First = productArray[2].first else { return [] }
        

        let productModel1 = ProductModel(productModel1First.productTypeName,
                                         productModel1First.productTypeId,
                                         caseModel1)
        let productModel2 = ProductModel(productModel2First.productTypeName,
                                         productModel2First.productTypeId,
                                         caseModel2)
        let productModel3 = ProductModel(productModel3First.productTypeName,
                                         productModel3First.productTypeId,
                                         caseModel3)
        
        return [productModel1, productModel2, productModel3]
    }
}

extension MainViewModel: Stepper {
    public func pick(compositionId: Int) {
        self.step.accept(InHeartStep.selected(compositionId: compositionId))
    }
}
