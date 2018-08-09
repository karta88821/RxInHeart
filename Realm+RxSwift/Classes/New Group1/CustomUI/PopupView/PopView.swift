//
//  PopView.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/28.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import SnapKit
import Reusable

enum PopupType {
    case allocate
    case orderInfo
}

class PopupView: UIView {
    
    // MARK: - Properties
    private var item: CartItem?
    private var deliveryInfo: DeliveryInfo?
    private var type: PopupType?
    
    // MARK : - UI
    var tableView: UITableView!
    let topView = UIView()
    let topLabel = UILabel()
    
    override init(frame: CGRect) {
        self.type = .allocate
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.type = .allocate
        super.init(coder: aDecoder)
        initUI()
    }
    
    init(type: PopupType) {
        super.init(frame: .zero)
        self.type = type
        initUI()
        constraintUI()
    }
    
    func setupAllocate(with item: CartItem) {
        self.item = item
        tableView.reloadData()
    }
    
    func setupOrderInfo(with deliveryInfo: DeliveryInfo) {
        self.deliveryInfo = deliveryInfo
        tableView.reloadData()
    }
}

private extension PopupView {
    func initUI() {
        backgroundColor = .white
        makeShadow(shadowOpacity: 0.3, shadowOffsetW: 0.3, shadowOffsetH: 0.3)
        
        topView.backgroundColor = .white
        
        let tableView = UITableView(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.register(cellType: PopupFoodCell.self)
        tableView.tableHeaderView = makeHeader()
        
        self.tableView = tableView
        addSubview(self.tableView)
    }

    
    func constraintUI() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func makeHeader() -> UIView {
        guard let type = type else { return UIView() }
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width: Int(frame.width), height: 50))
        let headerLabel = UILabel()
        let sepView = UIView()
        sepView.backgroundColor = sepBackground
        header.addSubViews(views: headerLabel, sepView)
        
        switch type {
        case .allocate:
            headerLabel.setupWithTitle(textAlignment: .left, fontSize: 20, textColor: grayColor, text: "商品內容")
            sepView.isHidden = true
        case .orderInfo:
            headerLabel.setupWithTitle(textAlignment: .center, fontSize: 20, textColor: grayColor, text: "宅配內容")
        }
        
        headerLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            switch type {
            case .allocate:
                $0.left.equalTo(25)
            case .orderInfo:
                $0.centerX.equalToSuperview()
            }
        }
        
        sepView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        return header
    }
}

extension PopupView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let type = type else { return 0 }
        switch type {
        case .allocate:
            return 1
        case .orderInfo:
            return deliveryInfo?.deliveryInfoCartItems.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let type = type else { return 0 }
        switch type {
        case .allocate:
            if let item = item {
                return item.getPickItems().count
            }
        case .orderInfo:
            return deliveryInfo?.deliveryInfoCartItems[section].cartItem.getPickItems().count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let type = type else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(for: indexPath) as PopupFoodCell
        switch type {
        case .allocate:
            if let pickItems = item?.getPickItems() {
                cell.item = pickItems[indexPath.row]
                cell.cellType = .allocatePopup
                return cell
            }
        case .orderInfo:
            if let deliveryInfoCartItems = deliveryInfo?.deliveryInfoCartItems {
                cell.item = deliveryInfoCartItems[indexPath.section].cartItem.getPickItems()[indexPath.row]
                cell.cellType = .orderPopup
                return cell
            }
        }
        return cell
    }
}

extension PopupView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let type = type else { return nil }
        switch type {
        case .allocate:
            return nil
        case .orderInfo:
            let header = CartItemHeaderView()
            if let deliveryInfo = deliveryInfo {
                header.deliveryInfoCartItem = deliveryInfo.deliveryInfoCartItems[section]
            }
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let type = type else { return 0 }
        switch type {
        case .allocate:
            return 0
        case .orderInfo:
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
