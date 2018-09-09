//
//  ObservableType+Codable.swift
//  RxInHeart
//
//  Created by liao yuhao on 2018/9/8.
//  Copyright © 2018 liao yuhao. All rights reserved.
//

import Foundation
import RxSwift
import Moya

public extension ObservableType where E == Response {
    public func mapObject<T: Decodable>(_ type: T.Type, path: String? = nil) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            return Observable.just(try response.mapObject(type, path: path))
        }
    }
    
    public func mapArray<T: Decodable>(_ type: T.Type, path: String? = nil) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            return Observable.just(try response.mapArray(type, path: path))
        }
    }
}
