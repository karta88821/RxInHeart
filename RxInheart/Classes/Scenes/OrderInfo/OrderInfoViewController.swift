//
//  OrderInfoViewController.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/26.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import SnapKit

class OrderInfoViewController: UIViewController {
    
    // MARK : - UI
    var tableView: UITableView!
    lazy var popupView: PopupView = {
        let popView = PopupView(type: .orderInfo)
        view.insertSubview(popView, aboveSubview: backgroundButton)
        
        popView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(1000)
            $0.left.right.equalToSuperview().inset(30)
            $0.height.equalTo(50)
        }
        
        return popView
    }()
    lazy var backgroundButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.alpha = 0
        button.addTarget(self, action: #selector(dismissView(_:)), for: .touchUpInside)
        view.addSubview(button)
        
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        return button
    }()
    
    // MARK : - Property
    var sendModel: SendOrderModel!
    
    // MARK : - ViewModel
    var viewModel: OrderInfoViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView(for: view)
        constraintUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    var itemCount: Int! {
        return sendModel.cartItems.count
    }
}

private extension OrderInfoViewController {
    
    func createViews() {
        configureTableView()
    }
    
    func configureView(for view: UIView) {
        createViews()
        view.backgroundColor = pinkBackground
        view.addSubview(tableView)
    }
    
    func configureTableView() {
        let header = SectionHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        header.type = .number(number: 0000001, date: Date())
        
        let footer = OrderInfoFooterView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 90))
        footer.popButton.addTarget(self, action: #selector(popNav(_:)), for: .touchUpInside)
        
        tableView = {
            let tv = UITableView(frame: .zero, style: .grouped)
            tv.showsVerticalScrollIndicator = false
            tv.backgroundColor = pinkBackground
            tv.separatorStyle = .none
            tv.register(cellType: PopupFoodCell.self)
            tv.register(cellType: OrderInfoCell.self)
            tv.register(cellType: PaymentInfoCell.self)
            tv.register(cellType: DeliveryContentCell.self)
            tv.register(cellType: TotalPriceCell.self)
            tv.tableHeaderView = header
            tv.tableFooterView = footer
            tv.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
            tv.dataSource = self
            tv.delegate = self
            
            return tv
        }()
    }

    @objc func popNav(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "", message: "確定要取消此訂單嗎？", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let conform = UIAlertAction(title: "確定", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        alert.addAction(cancel)
        alert.addAction(conform)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func dismissNav(_ sender: UIButton) {
        self.navigationController?.presentedViewController?.dismiss(animated: true)
    }
    
    @objc func dismissView(_ sender: Any) {
        popupView.snp.updateConstraints {
            $0.centerY.equalToSuperview().offset(1000)
        }
        self.backgroundButton.alpha = 0
    }
    
    func constraintUI() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension OrderInfoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return itemCount + 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0...(itemCount - 1):
            return sendModel.cartItems[section].pickedItem.count
        case itemCount, itemCount + 1, itemCount + 3:
            return 1
        case itemCount + 2:
            return infoManager.getCount()
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
            let cell = tableView.dequeueReusableCell(for: indexPath) as OrderInfoCell
            cell.setupUI(with: sendModel.orderInfo)
            return cell
        case itemCount + 1:
            let cell = tableView.dequeueReusableCell(for: indexPath) as PaymentInfoCell
            cell.setupUI(with: sendModel.paymentInfo, and: sendModel.totalPrice)
            return cell
        case itemCount + 2:
            let cell = tableView.dequeueReusableCell(for: indexPath) as DeliveryContentCell
            let info = infoManager.getValue(at: indexPath.row)
            cell.setupUI(with: info)
            cell.delegate = self
            return cell
        case itemCount + 3:
            let cell = tableView.dequeueReusableCell(for: indexPath) as TotalPriceCell
            cell.setupUI(with: sendModel.totalPrice, and: 80)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension OrderInfoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0...(itemCount - 1):
            return sendModel.cartItems[indexPath.section].expanded ? 65 : 0
        case itemCount, itemCount + 2:
            return 120
        case itemCount + 1, itemCount + 3:
            return 90
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
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0...(itemCount - 1):
            return 180
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}

extension OrderInfoViewController: BaseExpandable {
    func toggleSection(header: BaseExpandableView, section: Int) {

        sendModel.cartItems[section].expanded = !sendModel.cartItems[section].expanded

        tableView.beginUpdates()
        for i in 0 ..< sendModel.cartItems[section].pickedItem.count {
            tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        tableView.endUpdates()
    }
}

extension OrderInfoViewController: PopViewPresentable {
    func showPopup(item: CartItem?, deliveryInfo: DeliveryInfo?) {
        guard let deliveryInfo = deliveryInfo else { return }
        
        popupView.setupOrderInfo(with: deliveryInfo)
        
        let intValue = deliveryInfo.deliveryInfoCartItems
                        .map{$0.cartItem.pickedItem.count * 45 + 45}
                        .reduce(50, {$0 + $1})
        var contentH: CGFloat = CGFloat(intValue)
        
        contentH = (contentH > 500) ? 500 : contentH
        popupView.tableView.isScrollEnabled = (contentH > 500) ? true : false
        
        popupView.snp.updateConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(contentH)
        }
        
        self.backgroundButton.alpha = 0.3
    }

}
