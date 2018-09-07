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
    
    let services: AppServices
    
    private let disposeBag = DisposeBag()
    
    let databaseIsEmpty = Variable<Bool>(true)

    // MARK: - Output
    let products = Variable<[ProductPresentable]>([])

    init(services: AppServices) {
        self.services = services
    }
    
    func start() {
        DBManager.isEmpty()
            .subscribeOn(services.`$`.backgroundWorkScheduler)
            .observeOn(services.`$`.mainScheduler)
            .subscribe(onNext:{ [weak self] bool in
            switch bool {
            case true:
                self?.setupDatabase()
                sleep(3)
                self?.databaseIsEmpty.value = false
            case false:
                
                let productResults = DBManager.query(ProductEntity.self,
                                                     sort: SortOption(propertyName: "id", isAscending: true))
                self?.products.value = (self?.setupModel(with: productResults))!
                sleep(3)
                self?.databaseIsEmpty.value = false
            }
        })
        .disposed(by: disposeBag)
    }
    
    func setupDatabase() {
        services.productsService.getFoods()
            .subscribe(onNext:{ response in
                DBManager.write(response)
            },onError:{ error in
                print("數據請求失敗!錯誤原因：", error)
            })
            .disposed(by: disposeBag)
        
        services.productsService.getProducts()
            .subscribe(onNext:{ [weak self] response in
                self?.products.value = (self?.setupModel(with: response))!
                DBManager.write(response)
            },onError:{ error in
                print("數據請求失敗!錯誤原因：", error)
            })
            .disposed(by: self.disposeBag)
    }

    func setupModel(with products: [ProductEntity]) -> [ProductModel]{
        var productArray: [[ProductEntity]] = [[],[],[]] // 喜餅禮盒：雙鳳呈祥＋鳳凰于飛 // 彌月禮盒 // 婚禮小物
        
        products.forEach { result in
            switch result.productTypeId {
            case 1:
                productArray[0].append(result)
            case 2:
                productArray[1].append(result)
            case 3:
                productArray[2].append(result)
            default: break
            }
        }
        
        
        let caseModelsCollection = productArray.map { products -> [CasePresentable] in
            
            let newProducts = products.map { product -> CaseModel in
                if product.giftboxTypeId == 0 {
                    return CaseModel(giftboxName: product.name, giftboxId: product.giftboxTypeId, price: product.price, totalCount: 1, products: nil)
                } else {
                    let productEntities = products.filter {$0.giftboxTypeId == product.giftboxTypeId}
                    return CaseModel(giftboxName: product.name, giftboxId: product.giftboxTypeId, price: product.price, totalCount: product.totalCount, products: productEntities)
                }
            }
            
            if newProducts.first?.giftboxId != 0 {
                return newProducts.filterDuplicate{$0.giftboxId}
            }
            
            return newProducts
        }

        let firstProductCollection = productArray.map{$0.first!}
        let productModels = zip(firstProductCollection, caseModelsCollection)
            .map { (zip) -> ProductModel in

                let (product, caseModels) = zip
                return ProductModel(productTypeName: product.productTypeName,
                                    productTypeId: product.productTypeId,
                                    caseModels: caseModels)
            }

        return productModels
    }
}

extension MainViewModel: Stepper {
    public func pick(compositionId: Int) {
        self.step.accept(InHeartStep.selected(compositionId: compositionId))
    }
}
