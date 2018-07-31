//
//  Obserable+Extension.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/3/18.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType {
    
    func catchErrorJustComplete() -> Observable<E> {
        return catchError { _ in
            return Observable.empty()
        }
    }
    
    func asDriverOnErrorJustComplete() -> Driver<E> {
        return asDriver { error in
            return Driver.empty()
        }
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}
