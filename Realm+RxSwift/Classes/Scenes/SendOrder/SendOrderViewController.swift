//
//  SendOrderViewController.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/1.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit

class SendOrderViewController: UIViewController {
    
    // MARK : - UI
    var tableView: UITableView!
    let sendButton = UIButton()
    
    // MARK : - Property
    var sendModel: SendOrderModel!
    
    // MARK : - ViewModel
    var viewModel: SendOrderViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        constraintUI()
    }
    
    var itemCount: Int! {
        return sendModel.cartItems.count
    }
}

private extension SendOrderViewController {
    func initUI() {
        view.backgroundColor = pinkBackground
        
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.showsVerticalScrollIndicator = false
        tv.backgroundColor = pinkBackground
        tv.separatorStyle = .singleLine
        tv.register(cellType: PopupFoodCell.self)
        tv.register(cellType: DeliveryInfoCell.self)
        tv.register(cellType: PaymentInfoCell.self)
        tv.contentInset = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
        tv.dataSource = self
        tv.delegate = self
        
        let headerView = BaseAxisView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 75))
        headerView.position = .right
        let footerView = SendFooterView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 90))
        footerView.button.addTarget(self, action: #selector(goOrderInfo(_:)), for: .touchUpInside)
        
        tv.tableHeaderView = headerView
        tv.tableFooterView = footerView
        self.tableView = tv

        view.addSubViews(views: tableView)
    }
    
    
    @objc func goOrderInfo(_ sender: UIButton) {
        viewModel.goOrderInfo(with: sendModel)
    }
    
    func constraintUI() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension SendOrderViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return itemCount + 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0...(itemCount - 1):
            return sendModel.cartItems[section].pickedItem.count
        case itemCount:
            return infoManager.getCount()
        case itemCount + 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0...(itemCount - 1):
            let cell = tableView.dequeueReusableCell(for: indexPath) as PopupFoodCell
            let item = sendModel.cartItems[indexPath.section].items[indexPath.row]
            cell.item = item
            cell.expaned = sendModel.cartItems[indexPath.section].expanded
            cell.cellType = .allocatePopup
            return cell
        case itemCount:
            let cell = tableView.dequeueReusableCell(for: indexPath) as DeliveryInfoCell
            let info = infoManager.getValue(at: indexPath.row)
            cell.setupUI(with: info)
            return cell
        case itemCount + 1:
            let cell = tableView.dequeueReusableCell(for: indexPath) as PaymentInfoCell
            cell.setupUI(with: sendModel.paymentInfo, and: sendModel.totalPrice)
            return cell
        default:
            return UITableViewCell()
        }

    }
}

extension SendOrderViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0...(itemCount - 1):
            return sendModel.cartItems[indexPath.section].expanded ? 65 : 0
        case itemCount:
            return 120
        case itemCount + 1:
            return 150
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0...(itemCount - 1):
            let header = SendOrderExpandView()
            header.setupUI(cartItem: sendModel.cartItems[section], section: section, delegate: self)
            header.setupCountText(with: sendModel.cartItems[section].count)
            return header
        case itemCount:
            let header = SectionHeaderView()
            header.type = .delivery(title: "運送方式", state: sendModel.deliveryState.getString())
            return header
        case itemCount + 1:
            let header = SectionHeaderView()
            header.type = .payment(title: "付款方式", state: sendModel.paymentState.getString())
            return header
        default:
            return nil
        }

    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 0...(itemCount - 2):
            return nil
        case itemCount - 1:
            let footer = PriceView()
            footer.type = .cartItem
            footer.setupPriceText(with: sendModel.totalPrice)
            return footer
        case itemCount:
            let footer = PriceView()
            footer.type = .delivery
            footer.setupPriceText(with: 0)
            return footer
        case itemCount + 1:
            let footer = PriceView()
            footer.type = .payment
            footer.setupPriceText(with: sendModel.totalPrice)
            return footer
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0...(itemCount - 1):
            return 180
        case itemCount, itemCount + 1:
            return 50
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0...(itemCount - 2):
            return 0
        case itemCount - 1:
            return 65
        case itemCount, itemCount + 1:
            return 65
        default:
            return 0
        }
    }
    
}

extension SendOrderViewController: BaseExpandable {
    func toggleSection(header: BaseExpandView, section: Int) {
        
        sendModel.cartItems[section].expanded = !sendModel.cartItems[section].expanded
        
        tableView.beginUpdates()
        for i in 0 ..< sendModel.cartItems[section].pickedItem.count {
            tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        tableView.endUpdates()
    }
}
