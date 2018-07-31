//
//  Dependencies.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/14.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import RxSwift

import class Foundation.URLSession
import class Foundation.OperationQueue
import enum Foundation.QualityOfService

class Dependencies {
    
    // *****************************************************************************************
    // !!! This is defined for simplicity sake, using singletons isn't advised               !!!
    // !!! This is just a simple way to move services to one location so you can see Rx code !!!
    // *****************************************************************************************
    static let sharedDependencies = Dependencies() // Singleton
    
    let URLSession = Foundation.URLSession.shared
    let backgroundWorkScheduler: ImmediateSchedulerType
    let mainScheduler: SerialDispatchQueueScheduler
    
    private init() {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 2
        operationQueue.qualityOfService = QualityOfService.userInitiated
        backgroundWorkScheduler = OperationQueueScheduler(operationQueue: operationQueue)
        
        mainScheduler = MainScheduler.instance
    }
}
