//
//  MoyaProvider+Request.swift
//  RxInHeart
//
//  Created by liao yuhao on 2018/9/8.
//  Copyright © 2018 liao yuhao. All rights reserved.
//

import Foundation
import Moya

public extension MoyaProvider {
    
    // MARK : - 請求資料（返回單個物件）
    @discardableResult
    public func request<T: Decodable>(_ target: Target, objectModel: T.Type, path: String? = nil,
        success: ((_ returnData: T) -> ())?, failure: ((_ Error: MoyaError) -> ())?) -> Cancellable? {
        return request(target) { result in
            if let error = result.error {
                failure?(error)
                return
            }
            
            do {
                guard let returnData = try result.value?.mapObject(objectModel.self, path: path) else { return }
                success?(returnData)
            } catch {
                failure?(MoyaError.jsonMapping(result.value!))
            }
        }
    }
    
    // MARK : - 請求資料（返回陣列物件）
    @discardableResult
    public func request<T: Decodable>(_ target: Target, objectModel: T.Type, path: String? = nil,
                                    success: ((_ returnData: [T]) -> ())?, failure: ((_ Error: MoyaError) -> ())?) -> Cancellable? {
        return request(target) { result in
            if let error = result.error {
                failure?(error)
                return
            }
            
            do {
                guard let returnData = try result.value?.mapArray(objectModel.self, path: path) else { return }
                success?(returnData)
            } catch {
                failure?(MoyaError.jsonMapping(result.value!))
            }
        }
    }
}
