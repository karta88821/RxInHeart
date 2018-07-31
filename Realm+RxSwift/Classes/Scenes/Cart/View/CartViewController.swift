//
//  CartViewController.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/4/11.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import Reusable
import RxFlow
import RxSwift
import RxCocoa

class CartViewController: UIViewController, StoryboardBased, ViewModelBased {
    
    var viewModel: CartViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        viewModel.items
//            .drive(tableView.rx.items(cellIdentifier: "cartcell", cellType: UITableViewCell.self)) { row, item, cell in
//                cell.textLabel?.text = String(item.cartModel.price)
//            }
//            .disposed(by: rx.disposeBag)
        
    }
    
}
