//
//  RealmHelper.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/3/19.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
class RealmHelper: NSObject {
    /// MARK: - 創建資料庫
    /// 創建資料庫
    ///
    /// - Parameters:
    ///   - dataBaseName: 資料庫名稱
    ///   - isReadOnly: 是否是唯讀
    /// - Returns: Realm消息
    @discardableResult
    class func creatDB(_ dataBaseName: String, isReadOnly: Bool = false) -> Observable<Realm?> {
        return Observable.create({ (observable) -> Disposable in
            let realm = RealmUtility.default.creatDB(dataBaseName, isReadOnly: isReadOnly)
            observable.onNext(realm)
            return Disposables.create ()
        })
    }
    
    
    /// 預設資料庫配置
    ///
    /// - Parameters:
    ///   - realmName: 資料庫名稱
    ///   - isReference: 是否是引用資料庫
    ///   - isReadOnly: 是否是唯獨
    /// - Returns: 结果
    @discardableResult
    class func setDefaltRealmConfiguration(_ realmName: String,isReference: Bool = false, isReadOnly: Bool = false) -> Observable<Bool> {
        return Observable.create({ (observable) -> Disposable in
            let isSuccess = RealmUtility.default.setDefaltRealmConfiguration(realmName, isReference: isReference, isReadOnly: isReadOnly)
            observable.onNext(isSuccess)
            return Disposables.create()
        })
    }
    
    /// 打開預設的資料庫
    ///
    /// - Parameters:
    ///   - dataBaseName: 資料庫名稱
    ///   - isReadOnly: 是否是唯獨
    /// - Returns: Realm實例
    @discardableResult
    class func openReferenceDB(_ dataBaseName: String, isReadOnly: Bool = true) -> Observable<Realm?> {
        return Observable.create({ (observable) -> Disposable in
            let realm = RealmUtility.default.openReferenceDB(dataBaseName, isReadOnly: isReadOnly)
            observable.onNext(realm)
            return Disposables.create {
                
            }
        })
    }
    
    /// 取得當前預設的資料
    ///
    /// - Returns: 返回預設的Realm的資料庫實例
    @discardableResult
    class func getDefaultRealm() -> Observable<Realm?>  {
        return Observable.create({ (observable) -> Disposable in
            let realm = RealmUtility.default.getDefaultRealm()
            observable.onNext(realm)
            return Disposables.create {
                
            }
        })
    }
    
    /// MARK: - 新增
    /// 創建表 || 更新表
    ///
    /// - Parameters:
    ///   - type: 表向對應的對象
    ///   - value: 值
    ///   - update: 是否是更新, 如果是"true", Realm會找查對象並更新它, 否则添加對象
    /// - Returns: 创建的对象或者更新过后的对象
    @discardableResult
    class func creatObject(_ type: RealmSwift.Object.Type, value: Any? = nil, update: Bool = false) -> Observable<(RealmSwift.Object?, Error?)>{
        return Observable.create { (observable) -> Disposable in
            RealmUtility.default.creatObject(type, value: value, update: update, result: { (object, error) in
                observable.onNext((object, error))
            })
            return Disposables.create {
                
            }
        }
    }
    
    /// 添加資料 || 依據主键更新資料
    ///
    /// - Parameters:
    ///   - object: 要添加的資料
    ///   - update: 是否更新, 如果是true
    /// - Returns: 添加数据是否成功, error為空則成功, 不為空則失敗
    class func addObject(_ object: RealmSwift.Object, update: Bool = false) -> Observable<Error?> {
        return Observable.create({ (observable) -> Disposable in
            RealmUtility.default.addObject(object, update: update, result: { (error) in
                observable.onNext(error)
            })
            return Disposables.create {
                
            }
        })
    }
    
    /// MARK: - 删
    /// 删除資料
    ///
    /// - Parameters:
    ///   - object: 要删除的对象
    /// - Returns: 删除資料是否成功, error為空則成功, 不為空則失敗
    class func deleteObject(_ object: RealmSwift.Object) -> Observable<Error?> {
        return Observable.create({ (observable) -> Disposable in
            RealmUtility.default.deleteObject(object, result: { (error) in
                observable.onNext(error)
            })
            return Disposables.create {
                
            }
        })
    }
    
    /// 删除当前数据库中所有的数据
    ///
    /// - Returns: 添加数据库中的所有数据是否成功, error为空则成功, 不为空则失败
    @discardableResult
    class func deleteAllObject() -> Observable<Error?> {
        return Observable.create({ (observable) -> Disposable in
            RealmUtility.default.deleteAllObject(result: { (error) in
                observable.onNext(error)
            })
            return Disposables.create {
                
            }
        })
    }
    
    /// 删除当前打开的数据库
    ///
    /// - Parameter dataBaseName: 数据库的名字
    /// - Returns: 删除当前打开的数据是否成功
    @discardableResult
    class func deleteCreatDBFile() -> Observable<Bool> {
        return Observable.create({ (observable) -> Disposable in
            let isSuccess = RealmUtility.default.deleteCreatDBFile()
            observable.onNext(isSuccess)
            return Disposables.create()
        })
    }
    
    //MARK: - 改
    /// 根据主键进行更新
    ///
    /// - Parameters:
    ///   - object: 要更新的对象
    ///   - update: 是否根据主键更新, 如果是"false"则是添加数据
    /// - Returns: 根据主键进行更新是否成功, error为空则成功, 不为空则失败
    @discardableResult
    class func updateObject(_ object: RealmSwift.Object, update: Bool = true) -> Observable<Error?> {
        return Observable.create({ (observable) -> Disposable in
            RealmUtility.default.updateObject(object, update: update, result: { (error) in
                observable.onNext(error)
            })
            return Disposables.create()
        })
    }
    
    
    /// 根据主键进行更新
    ///
    /// - Parameters:
    ///   - type: 要更新的对象类型
    ///   - value: 要更新的值, 例如: ["id": 1, "price": 9000.0]
    ///   - update: 是否根据主键进行更新, 如果为"false"则为创建表
    /// - Returns: 根据主键进行更新是否成功, error为空则成功, 不为空则失败
    @discardableResult
    class func updateObject(_ type: RealmSwift.Object.Type, value: Any? = nil, update: Bool = true) -> Observable<(RealmSwift.Object?, Error?)> {
        return Observable.create({ (observable) -> Disposable in
            RealmUtility.default.updateObject(type, value: value, update: update, result: { (object, error) in
                observable.onNext((object, error))
            })
            return Disposables.create()
        })
    }
    
    
    /// 直接更新对象
    ///
    /// - Parameters:
    ///   - property: 要更改的属性
    ///   - value: 更改的值
    /// - Returns: 更改的结果
    //@discardableResult
    //public class func updateObject(_ property: inout Any, value: Any) -> Observable<Bool> {
    //    return Observable.create({ (observable) -> Disposable in
    //        let isSuccess = RealmUtility.default.updateObject(property: &property, value: value)
    //        observable.onNext(isSuccess)
    //        return Disposables.create()
    //    })
    //}
    
    
    /// 更改表中所有的字段的值
    ///
    /// - Parameters:
    ///   - type: 表的對象類型
    ///   - key: 要更改的字段名
    ///   - value: 更改的值
    /// - Returns: 更改表中所有的字段的值是否成功
    @discardableResult
    class func updateObjects(type: RealmSwift.Object.Type, key: String, value: Any) -> Observable<Bool> {
        return Observable.create({ (observable) -> Disposable in
            let isSuccess = RealmUtility.default.updateObjects(type: type, key: key, value: value)
            observable.onNext(isSuccess)
            return Disposables.create()
        })
    }
    
    
    /// 根據主鍵进行对某个对象中的数据进行更新
    ///
    /// - Parameters:
    ///   - type: 表类型
    ///   - primaryKey: 主键
    ///   - key: 要更改属性
    ///   - value: 更改的值
    /// - Returns: 根据主键进行对某个对象中的数据进行更新是否成功
    @discardableResult
    class func updateObject(type: RealmSwift.Object.Type, primaryKey: Any, key: String, value: Any) -> Observable<Bool> {
        return Observable.create({ (observable) -> Disposable in
            let isSuccess = RealmUtility.default.updateObject(type: type, primaryKey: primaryKey, key: key, value: value)
            observable.onNext(isSuccess)
            return Disposables.create()
        })
    }
    
    /// MARK: - 查
    /// 查找一個表中的所有的資料
    ///
    /// - Parameter type: 對象類型
    /// - Returns: 查到的資料
    @discardableResult
    class func getObjects(type: RealmSwift.Object.Type) -> Observable<RealmSwift.Results<RealmSwift.Object>?>{
        return Observable.create({ (obsevable) -> Disposable in
            let objects = RealmUtility.default.getObjects(type: type)
            obsevable.onNext(objects)
            return Disposables.create()
        })
    }
    
    /// 根据主键查找某个对象
    ///
    /// - Parameters:
    ///   - type: 對象类型
    ///   - primaryKey: 主键
    /// - Returns: 查到的数据
    @discardableResult
    class func getObjectWithPrimaryKey(type: RealmSwift.Object.Type, primaryKey: Any) -> Observable<RealmSwift.Object?> {
        return Observable.create({ (observable) -> Disposable in
            let object = RealmUtility.default.getObjectWithPrimaryKey(type: type, primaryKey: primaryKey)
            observable.onNext(object)
            return Disposables.create()
        })
    }
    
    
    /// 使用断言字符串查询
    ///
    /// - Parameters:
    ///   - type: 对象类型
    ///   - filter: 过滤条件
    /// - Returns: 查询到的数据
    /// - example:
    ///   - var tanDogs = realm.objects(Dog.self).filter("color = 'tan' AND name BEGINSWITH 'B'")
    @discardableResult
    class func getObject(type: RealmSwift.Object.Type, filter: String) -> Observable<RealmSwift.Results<RealmSwift.Object>?> {
        return Observable.create({ (observable) -> Disposable in
            let objects = RealmUtility.default.getObject(type: type, filter: filter)
            observable.onNext(objects)
            return Disposables.create()
        })
    }
    
    
    /// 使用谓词进行查询
    ///
    /// - Parameters:
    ///   - type: 对象类型
    ///   - predicate: 谓词对象
    /// - Returns: 查询到的数据
    /// - example:
    ///   - let predicate = NSPredicate(format: "color = %@ AND name BEGINSWITH %@", "tan", "B")
    ///   - tanDogs = realm.objects(Dog.self).filter(predicate)
    @discardableResult
    class func getObject(type: RealmSwift.Object.Type, predicate: NSPredicate) -> Observable<RealmSwift.Results<RealmSwift.Object>?> {
        return Observable.create({ (observable) -> Disposable in
            let object = RealmUtility.default.getObject(type: type, predicate: predicate)
            observable.onNext(object)
            return Disposables.create()
        })
    }
    
    
    /// 对查询的数据进行排序
    ///
    /// - Parameters:
    ///   - type: 对象类型
    ///   - filter: 过滤条件
    ///   - sortedKey: 需要排序的字段
    /// - Returns: 最后的结果
    /// - notice: 请注意, 不支持 将多个属性用作排序基准，此外也无法链式排序（只有最后一个 sorted 调用会被使用）。 如果要对多个属性进行排序，请使用 sorted(by:) 方法，然后向其中输入多个 SortDescriptor 对象。
    @discardableResult
    class func getObject(type: RealmSwift.Object.Type, filter: String, sortedKey: String) -> Observable<RealmSwift.Results<RealmSwift.Object>?> {
        return Observable.create({ (observable) -> Disposable in
            let object = RealmUtility.default.getObject(type: type, filter: filter, sortedKey: sortedKey)
            observable.onNext(object)
            return Disposables.create()
        })
    }
    
    /// 对查询的数据进行排序
    ///
    /// - Parameters:
    ///   - type: 队形类型
    ///   - predicate: 谓词对象
    ///   - sortedKey: 排序的字段
    /// - Returns: 排序后的数据
    /// - notice: 请注意, 不支持 将多个属性用作排序基准，此外也无法链式排序（只有最后一个 sorted 调用会被使用）。 如果要对多个属性进行排序，请使用 sorted(by:) 方法，然后向其中输入多个 SortDescriptor 对象。
    @discardableResult
    class func getObject(type: RealmSwift.Object.Type, predicate: NSPredicate, sortedKey: String) -> Observable<RealmSwift.Results<RealmSwift.Object>?> {
        return Observable.create({ (observable) -> Disposable in
            let objects = RealmUtility.default.getObject(type: type, predicate: predicate, sortedKey: sortedKey)
            observable.onNext(objects)
            return Disposables.create()
        })
    }
}
