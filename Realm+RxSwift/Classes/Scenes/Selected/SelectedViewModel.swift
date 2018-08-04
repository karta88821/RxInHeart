//
//  CompositionViewModel.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/2/26.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFlow

class SelectedViewModel {
    
    private let disposeBag = DisposeBag()
    
    var services: APIDelegate!
    
    // MARK : Input
    let tapBtnCell = PublishSubject<GiftBoxViewModel>()
    let tapBtnIndexPath = PublishSubject<IndexPath>()
    let tapMidCell = PublishSubject<FoodItemViewModel>()
    let tapMidIndexPath = PublishSubject<IndexPath>()
    
    // MARK : Output
    let giftBoxItems = Variable<[GiftBoxViewModel]>([])
    let foodItems = Variable<[FoodItemViewModel]>([])
    let product: Observable<Product>
    
    let cuurrentIndexPath = Variable<Int>(0)
    
    let currentProductName: Driver<String>
    let currentCategoryName: Driver<String>

    let gbButtomIndex = Variable<Int>(0)
    let gbMidIndex = Variable<Int>(0)
    
    let pickItems = Variable<[NewPickItem]>([])

    
    
    init?(id: Int) {
        
        services = APIClient.sharedAPI
        
        guard let productResult = DBManager.query(ProductEntity.self, withPrimaryKey: id) else {return nil}
        
        let productObservable = Observable.from(object: productResult)
        
        let giftBoxItemsObservable = productObservable
                                        .map { Array($0.items).map{GiftBoxViewModel(with:$0) }}
        
        giftBoxItemsObservable
            .bind(to: giftBoxItems)
            .disposed(by: disposeBag)
        
        self.product = productObservable.map{Product(with: $0)}
        
        giftBoxItemsObservable.map{$0.map{NewPickItem(count: String($0.count), foodId: String(0))}}
            .bind(to: pickItems)
            .disposed(by: disposeBag)

        tapBtnCell
            .startWith(giftBoxItems.value[gbButtomIndex.value])
            .map { giftBoxItem -> [FoodItemViewModel] in
                let foodCategoryId = giftBoxItem.foodCategoryId
                let foodResult =
                    DBManager.query(FoodEntity.self,filter: NSPredicate(format: "foodCategoryId == \(foodCategoryId)"))
                
                let foodList = foodResult.map { FoodItemViewModel(with: $0)}
                return foodList
            }
            .bind(to: foodItems)
            .disposed(by: disposeBag)
        
        self.currentCategoryName = tapBtnCell.asDriver(onErrorDriveWith: .empty())
            .startWith(giftBoxItems.value[gbMidIndex.value])
            .map{$0.foodCategoryName}
        
        
        self.currentProductName = tapMidCell
            .startWith(foodItems.value[gbMidIndex.value])
            .asDriver(onErrorDriveWith: .empty()).map{ $0.name }

        tapBtnIndexPath.asObservable().map{$0.row}.bind(to: gbButtomIndex).disposed(by: disposeBag)
        tapMidIndexPath.asObservable().map{$0.row}.bind(to: gbMidIndex).disposed(by: disposeBag)
        
        
    }
    
}
