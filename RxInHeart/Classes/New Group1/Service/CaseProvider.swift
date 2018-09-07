//
//  CaseProvider.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/3/18.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import Foundation
import RxSwift
import Realm
import RealmSwift

protocol DBStrategy {
    associatedtype R
    func items() -> Observable<[R]>
    func save(items: [R]) -> Observable<Void>
}

class CaseProvider: DBStrategy {
    
    private let repository: Repository<RMCase>
    
    init(repository: Repository<RMCase>) {
        self.repository = repository
    }
    
    func items() -> Observable<[RMCase]> {
        return repository.queryAll()
    }
    
    func save(items: [RMCase]) -> Observable<Void> {
        return repository.save(entities: items)
    }
    
}

class RealmProvider {
    
    private let config: Realm.Configuration
     
    init(config: Realm.Configuration = Realm.Configuration()) {
        self.config = config
        
    }


}
