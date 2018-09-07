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
import UIKit

protocol AddCartItem {
    func addItem(success: @escaping (String,String) -> Void,
                 failure: @escaping (String,String) -> Void,
                 haventSelect: @escaping (String,String) -> Void)
}

class SelectedViewModel {
    
    private let disposeBag = DisposeBag()
    
    let services: AppServices
    
    // MARK : Input
    let tapBtnCell = PublishSubject<GiftboxItem>()
    let tapBtnIndexPath = PublishSubject<IndexPath>()
    let tapMidCell = PublishSubject<FoodEntity>()
    let tapMidIndexPath = PublishSubject<IndexPath>()
    
    // MARK : Output
    let giftBoxItems = Variable<[GiftboxItem]>([])
    let foodItems = Variable<[FoodEntity]>([])
    let product: Observable<ProductEntity>
    
    let cuurrentIndexPath = Variable<Int>(0)
    
    let currentProductName: Driver<String>
    let currentCategoryName: Driver<String>

    let gbButtomIndex = Variable<Int>(0)
    let gbMidIndex = Variable<Int>(0)
    
    let pickItems = Variable<[NewPickItem]>([])
    
    init?(id: Int, services: AppServices) {
        
        self.services = services
        
        guard let productResult = DBManager.query(ProductEntity.self, withPrimaryKey: id) else {return nil}
        
        let productObservable = Observable.from(object: productResult)
 
        let giftBoxItemsObservable = productObservable.map { Array($0.items)}
        
        giftBoxItemsObservable
            .bind(to: giftBoxItems)
            .disposed(by: disposeBag)
        
        self.product = productObservable
        
        giftBoxItemsObservable
            .map{$0.map{ NewPickItem(count: $0.count, foodId: 0)}}
            .bind(to: pickItems)
            .disposed(by: disposeBag)

        tapBtnCell
            .startWith(giftBoxItems.value[gbButtomIndex.value])
            .map { giftBoxItem -> [FoodEntity] in
                let foodCategoryId = giftBoxItem.foodCategoryId
                let foodResult = DBManager.query(
                    FoodEntity.self,
                    filter: NSPredicate(
                        format: "foodCategoryId == \(foodCategoryId)")
                )
                return foodResult
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

extension SelectedViewModel: AddCartItem {
    func addItem(success: @escaping (String,String) -> Void,
                 failure: @escaping (String,String) -> Void,
                 haventSelect: @escaping (String,String) -> Void) {
        
        let selectedContainZero = pickItems.value.contains {$0.foodId == 0}
        
        if selectedContainZero {
            return haventSelect("錯誤", "還沒選完喔")
        } else {
            product.subscribe(onNext:{ product in
                let newCartItem = NewCartItem(count: 1, subtotal: product.price, cartId: 1, productId: product.id, pickedItems: self.pickItems.value)
                
                self.services.cartService.addItem(item: newCartItem)
                    .subscribe(onNext:{ bool in
                        return bool ? success("購物車","已將商品加入購物車") : failure("購物車","無法加入購物車")
                    })
                    .disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
        }
    }
    
    func changeSection(index: Int) {
        let btmIndex = gbButtomIndex.value
        pickItems.value[btmIndex].index = index
        
        let foods = foodItems.value
        pickItems.value[btmIndex].foodId = foods[pickItems.value[btmIndex].index].id
    }
}
