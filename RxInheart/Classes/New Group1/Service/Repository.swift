//
//  RealmInstance.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/3/13.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import Realm
import RealmSwift
import RxSwift
import RxRealm

class Repository<T: Object>: NSObject {

    private let configuration: Realm.Configuration
    
    private var realm: Realm {
        return try! Realm(configuration: self.configuration)
    }
    
    init(configuration: Realm.Configuration) {
        self.configuration = configuration
    }
    
    func queryAll() -> Observable<[T]> {
        return Observable.deferred {
            let realm = self.realm
            let objects = realm.objects(T.self)
            
            return Observable.array(from: objects)
        }
    }
    
    func query(with predicate: NSPredicate, sortedby key: String) -> Observable<[T]> {
        return Observable.deferred {
            let realm = self.realm
            let objects = realm.objects(T.self)
                .filter(predicate).sorted(byKeyPath: key, ascending: true)
            
            return Observable.array(from: objects)
        }
    }
    
    func save(entities: [T]) -> Observable<Void> {
        return Observable.deferred {
            self.realm.rx.save(entities: entities)
        }
    }
}





