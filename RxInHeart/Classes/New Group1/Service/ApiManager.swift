//
//  ApiManager.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/2/14.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import Moya
import RxSwift
import RealmSwift
import RxCocoa

enum ApiManager {
    case products //所有商品
    case foods // 所有食品
    case food(categoryId: Int) // 取得指定種類食品
    case cart // 購物車內容  // (id: Int) 目前id先用1做測試
    case updateCart(cartId: Int, cartItemId: Int, cartItem: CartItem) // 更新購物車項目內容
    case addCartItem(cartId: Int, item: NewCartItem) // 新增購物車項目
    case deleteCartItem(cartId: Int, cartItemId: Int) // 刪除購物車項目
}

extension ApiManager: TargetType {
    
    var baseURL: URL {
        return URL(string:"http://163.18.22.78:1003/api")!
    }

    var path: String {
        switch self {
        case .products:
            return "/Products"
        case .foods:
            return "/Foods"
        case .food(let categoryId):
            return "/Foods/GetFoodsByCategoryId/\(categoryId)"
        case .cart:
            return "/Carts/1"
        case let .updateCart(cartId, cartItemId, _):
            return "/Carts/PutCartItem/\(cartId)/cartItemId/\(cartItemId)"
        case let .addCartItem(cartId, _):
            return "/Carts/AddCartItem/\(cartId)"
        case let .deleteCartItem(cartId, cartItemId):
            return "/Carts/DeleteCartItem/\(cartId)/cartItemId/\(cartItemId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .products:
            return .get
        case .foods:
            return .get
        case .food(_):
            return .get
        case .cart:
            return .get
        case .updateCart(_,_,_):
            return .put
        case .addCartItem(_,_):
            return .post
        case .deleteCartItem(_,_):
            return .delete
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case let .addCartItem(_, item):
            guard let parameters = item.toDictionary() else { return .requestPlain }
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case let .updateCart(_, _, cartItem):
            guard let parameters = cartItem.toDictionary() else { return .requestPlain }
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var validate: Bool {
        return false
    }
}
