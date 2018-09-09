//
//  Encodable+toDictionary.swift
//  RxInHeart
//
//  Created by liao yuhao on 2018/9/9.
//  Copyright © 2018 liao yuhao. All rights reserved.
//

import Foundation

extension Encodable {
    func toDictionary() -> [String: Any]? {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self),
            let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else { return nil }
        
        return jsonObject as? [String: Any]
    }
}
