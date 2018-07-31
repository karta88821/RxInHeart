//
//  CartItemSectionState.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/23.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import Foundation

enum TableViewEditingCommand {
    case deleteItem(Int)
}

struct CartItemSectionState {
    var sections: [CartItem]
    
    init(sections: [CartItem]) {
        self.sections = sections
    }
    
    func execute(command: TableViewEditingCommand) -> CartItemSectionState {
        switch command {
        case .deleteItem(let index):
            var sections = self.sections
            sections.remove(at: index)
            sections[index] = CartItem(original: sections[index], items: sections[index].pickedItem)
            return CartItemSectionState(sections: sections)
        }
        
    }
}
