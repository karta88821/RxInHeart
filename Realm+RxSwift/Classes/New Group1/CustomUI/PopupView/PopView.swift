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
    var topView: UIView!
    let topLabel = UILabel()
    
//    override init(frame: CGRect) {
//        self.type = .allocate
//        super.init(frame: frame)
//        initUI()
//    }
//
    required init?(coder aDecoder: NSCoder) {
        self.type = .allocate
        super.init(coder: aDecoder)
        createViews()
        configureView()
        constraintUI()
    }
    
    init(type: PopupType) {
        super.init(frame: .zero)
        self.type = type
        createViews()
        configureView()
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
    
    func createViews() {
        configureTableView()
        configureTopView()
    }
    
    func configureView() {
        backgroundColor = .white
        makeShadow(shadowOpacity: 0.3, shadowOffsetW: 0.3, shadowOffsetH: 0.3)
        addSubview(tableView)
    }
    
    func configureTableView() {
        tableView = {
            let tableView = UITableView(frame: .zero)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.backgroundColor = .white
            tableView.separatorStyle = .none
            tableView.showsVerticalScrollIndicator = false
            tableView.isScrollEnabled = false
            tableView.register(cellType: PopupFoodCell.self)
            tableView.tableHeaderView = makeHeader()
            return tableView
        }()
    }
    
    func configureTopView() {
        topView = UIView(backgroundColor: .white)
    }

    func constraintUI() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func makeHeader() -> UIView {
        guard let type = type else { return UIView() }
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width: Int(frame.width), height: 50))
        var headerLabel: UILabel!
        let sepView = UIView()
        sepView.backgroundColor = sepBackground

        switch type {
        case .allocate:
            headerLabel = UILabel(alignment: .left, fontSize: 20, text: "商品內容")
            sepView.isHidden = true
        case .orderInfo:
            headerLabel = UILabel(alignment: .center, fontSize: 20, text: "宅配內容")
        }
        
        header.addSubViews(views: headerLabel, sepView)
        
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
            $0.left.right.equalToSuperview().inset(20).priority(750)
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
                return item.pickedItem.count
            }
        case .orderInfo:
            return deliveryInfo?.deliveryInfoCartItems[section].cartItem.pickedItem.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let type = type else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(for: indexPath) as PopupFoodCell
        switch type {
        case .allocate:
            if let pickItems = item?.pickedItem {
                cell.item = pickItems[indexPath.row]
                cell.cellType = .allocatePopup
                return cell
            }
        case .orderInfo:
            if let deliveryInfoCartItems = deliveryInfo?.deliveryInfoCartItems {
                cell.item = deliveryInfoCartItems[indexPath.section].cartItem.pickedItem[indexPath.row]
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
