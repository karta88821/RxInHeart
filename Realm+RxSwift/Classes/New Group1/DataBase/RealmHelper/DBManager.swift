//
//  DBManager.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/5/30.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import RealmSwift
import RxSwift
import RxCocoa
import RxRealm

struct SortOption {
    var propertyName: String // 根據參數名作排序
    var isAscending: Bool // 是否升序
}

class DBManager<T: DBBaseBean>: NSObject {
    
    class func isEmpty() -> Observable<Bool> {
        let realm = realmInstance()
        let empty = realm?.isEmpty ?? true
        return  Observable.just(empty)
    }
    
    class func create(_ type: T.Type, value:Any) -> T?{
        let realm = realmInstance()
        return realm?.create(type, value: value)
    }
    
    /// Insert single obj or many objs to database
    class func write(_ objs:[T]) {
        guard objs.count > 0 else { return }
        
        let realm = realmInstance()
        
        do {
            try realm?.write {
                if objs.count == 1 {
                    if let item = objs.first {
                        realm?.add(item, update: true)
                    }
                } else {
                    realm?.add(objs, update: true)
                }
            }
        } catch let err as NSError {
            print("fail to write transaction: \(err.description)")
        }
    }
    
    /// update single obj or many objs, the update session need to do in closure
    class func update(_ session: (() -> Void)) {
        let realm = realmInstance()
        do {
            realm?.beginWrite()
            session()
            try realm?.commitWrite()
        } catch let err as NSError {
            print("fail to update transaction: \(err.description)")
        }
    }
    
    /// query objs in database
    class func query(_ type:T.Type, filter:NSPredicate? = nil, sort:SortOption? = nil) -> [T] {
        let realm = realmInstance()
        var results = realm?.objects(type)
        
        if filter != nil {
            results = results?.filter(filter!)
        }
        
        if sort != nil {
            results = results?.sorted(byKeyPath: sort!.propertyName, ascending: sort!.isAscending)
        }
        
        if results != nil {
            var convertResult:[T] = []
            (0..<results!.count).forEach { i in
                let item = results![i]
                convertResult.append(item)
            }
            return convertResult
        } else {
            return []
        }
    }
    
    /// query obj with its primary key
    class func query<K>(_ type:T.Type, withPrimaryKey key:K) -> T? {
        let realm = realmInstance()
        let target = realm?.object(ofType: type, forPrimaryKey: key)
        
        return target
    }
    
    /// delete target objs
    class func delete(_ objs: [T]) {
        guard objs.count > 0 else { return }
        
        let realm = realmInstance()
        
        do {
            try realm?.write {
                if objs.count == 1 {
                    if let item = objs.first {
                        realm?.delete(item)
                    }
                } else {
                    realm?.delete(objs)
                }
            }
        } catch let err as NSError {
            print("fail to delete transaction: \(err.description)")
        }
    }
    
    /// delete target objs, if filter is nil, it will delete all target type objs
    class func delete(_ type:T.Type, filter:NSPredicate? = nil) {
        let targetObjs = self.query(type, filter: filter)
        self.delete(targetObjs)
    }
    
    /// delete target obj
    class func delete<K>(_ type:T.Type, withPrimaryKey key:K) {
        
        if let target = self.query(type, withPrimaryKey: key) {
            self.delete([target])
        } else {
            print("delete fail, obj is not exist")
        }
    }
    
    /// delete all objs in database
    class func cleanDB() {
        let realm = realmInstance()
        
        do {
            try realm?.write {
                realm?.deleteAll()
            }
        } catch let err as NSError {
            print("fail to clean transaction: \(err.description)")
        }
    }
    
    class func fileUrl() {
        let realm = realmInstance()
        print(realm?.configuration.fileURL! ?? "")
    }
    
    fileprivate class func realmInstance() -> Realm? {
        if let config = DBConfig.shared.realmConfig {
            
            var instance: Realm? = nil
            do {
                instance = try Realm(configuration: config)
            } catch let err as NSError {
                print("init realm db fail: \(err.description)")
            }
            return instance
        } else {
            print("init realm db fail: !!!config is nil!!!")
            return nil
        }
    }
}

