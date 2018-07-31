//
//  Realm+Rxswift.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/3/17.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import RxSwift

extension Reactive where Base: Realm {
    func save<O: Object>(entities: [O], update: Bool = true) -> Observable<Void> {
        return Observable.create { observer in
            do {
                try self.base.write {
                    self.base.add(entities, update: update)
                }
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
}
