//
//  DBConfig.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/5/30.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import RealmSwift

class DBConfig: NSObject {
    
    static let shared = DBConfig()
    
    internal var realmConfig: Realm.Configuration? = nil
    
    func customConfig(_ config: Realm.Configuration) {
        self.realmConfig = config
    }
    
    func dbVersionMerge(_ m: Migration, newVer: UInt64, oldVer: UInt64) {
        print("版本合併")
        
        // 資料遷移
        //        m.enumerateObjects(ofType: DogBean.className(), { (oldObj, newObj) in
        //
        //            if oldVer < newVer {
        //
        //                if oldObj != nil && newObj != nil {
        //                    if let oldVal = oldObj!["gender"] as? Bool {
        //                        newObj!["gender"] = oldVal ? 10:20;
        //                    }
        //                }
        //            }
        //        })
        
        if oldVer < newVer {
            // 舊->新資料遷移迁移
        } else {
            //
        }
    }
    private override init() {
        super.init()
        realmConfig = Realm.Configuration.defaultConfiguration
    }
    
    //    private override init() {
    //        super.init()
    //
    //        var sourceKey: String = ""
    //        (0...9).forEach { i in
    //            sourceKey += "\(i)"
    //        }
    //        sourceKey += "fOzACGGgRu"
    //        (0...9).reversed().forEach { i in
    //            sourceKey += "\(i)"
    //        }
    //        sourceKey += "tVidwjUQn9q6TfkyHtBXWj5sHEeGh6nIYe"
    //
    //        // 64 位加密key
    //        let key: Data = sourceKey.data(using: String.Encoding.utf8, allowLossyConversion: false)!
    //        let keyStr: String = String(format: "%@", key as CVarArg)
    //        print("#KEY#" + keyStr)
    //
    //        var schemaVersion:UInt64 = UInt64(1);
    //        if let bundleInfo = Bundle.main.infoDictionary {
    //            if let buildVersion = bundleInfo["CFBundleVersion"] as? String, let num = UInt64(buildVersion) {
    //                schemaVersion = num+1000;
    //            }
    //        }
    //
    //        let filePath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appending("/FSDB.realm")
    //
    //        self.realmConfig = Realm.Configuration(fileURL: URL(string:filePath), inMemoryIdentifier: nil, syncConfiguration: nil, encryptionKey: key, readOnly: false, schemaVersion: schemaVersion, migrationBlock: {[unowned self] (m:Migration, oldSchemaVersion:UInt64) in
    //
    //            self.dbVersionMerge(m, newVer: schemaVersion, oldVer: oldSchemaVersion)
    //
    //            }, deleteRealmIfMigrationNeeded: false, shouldCompactOnLaunch:nil, objectTypes: nil)
    //
    //        /// 發生版本合併時會清理本地資料，防止崩潰
    //        self.realmConfig?.deleteRealmIfMigrationNeeded = true
    //    }
    
}
