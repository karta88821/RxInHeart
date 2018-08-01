//
//  Test.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/8/2.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//
//
//import Foundation
//
//func setupModel(with products: [ProductEntity]) -> [ProductModel]{
//    var productArray: [[ProductEntity]] = [[],[],[]] // 喜餅禮盒：雙鳳呈祥＋鳳凰于飛 // 彌月禮盒 // 婚禮小物
//    
//    products.forEach { results in
//        switch results.productTypeId {
//        case 1:
//            productArray[0].append(results)
//        case 2:
//            productArray[1].append(results)
//        case 3:
//            productArray[2].append(results)
//        default: break
//        }
//    }
//    
//    let caseModelArray = productArray.map { product -> [CaseModel] in
//        if product.first?.giftboxTypeId != 0 {
//            return product.map{CaseModel($0.giftboxTypeName!,
//                                         $0.giftboxTypeId,
//                                         $0.price,
//                                         Array($0.items).map{$0.count}.reduce(0, {$0 + $1}))}
//                .filterDuplicate{$0.giftboxId}
//            
//        } else {
//            return []
//        }
//    }
//    
//    let firstArray = productArray.map{$0.first!}.map{ProductModel($0.productTypeName,$0.productTypeId,[])}
//    firstArray.forEach { first in
//        var index = 0
//        first.caseModels = caseModelArray[index]
//        index += 1
//    }
//    //
//    //
//    //
//    //        guard let productModel1First = productArray[0].first
//    //            let productModel2First = productArray[1].first,
//    //            let productModel3First = productArray[2].first else { return  }
//    //
//    //
//    //        let productModel1 = ProductModel(productModel1First.productTypeName,
//    //                                         productModel1First.productTypeId,
//    //                                         caseModel1)
//    //        let productModel2 = ProductModel(productModel2First.productTypeName,
//    //                                         productModel2First.productTypeId,
//    //                                         caseModel2)
//    //        let productModel3 = ProductModel(productModel3First.productTypeName,
//    //                                         productModel3First.productTypeId,
//    //                                         [])
//    
//    return firstArray
//}
