//
//  FormViewController.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/1.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import M13Checkbox
import RxDataSources

class FormViewController: UIViewController {
    
    // MARK : - UI
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.backgroundColor = pinkBackground
        tv.tableHeaderView = headerView
        tv.tableFooterView = footerView
        // 讓section0的陰影能不被遮住
        tv.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        tv.showsVerticalScrollIndicator = false
        tv.separatorStyle = .singleLine
        tv.register(cellType: DeliveryCell.self)
        tv.register(cellType: PaymentCell.self)
        tv.register(headerFooterViewType: DeliveryHeaderView.self)
        tv.register(headerFooterViewType: PaymentHeaderView.self)
        tv.register(headerFooterViewType: CheckmarkHeaderView.self)
        self.view.addSubview(tv)
        return tv
    }()
    
    lazy var headerView: BaseAxisView = {
        let view = BaseAxisView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80))
        view.position = .middle
        view.backgroundColor = pinkBackground
        return view
    }()
    
    lazy var footerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
        view.backgroundColor = pinkBackground
        
        let button = UIButton()
        button.setup(title: "NEXT", textColor: .white)
        button.makeShadow(cornerRadius: 20, shadowOpacity: 0.2, shadowOffsetH: 0.3)
        button.clipsToBounds = true
        button.backgroundColor = pinkButtonBg!
        button.addTarget(self, action: #selector(validationAction(_:)), for: .touchUpInside)
        view.addSubViews(views: button)
        button.snp.makeConstraints {
            $0.width.equalTo(180)
            $0.height.equalTo(40)
            $0.center.equalToSuperview()
        }
        
        return view
    }()
    
    // MARK : - Property
    var sections = [FormMutipleSectionModel]()
    
    // MARK : - ViewModel
    var viewModel: FormViewModel!
    
    // MARK : - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        bindUI()
        constraintUI()
        hideKeyboard()
        addObserver()
    }
    
    @objc func insetDelivery(_ notification: Notification) {
        
        guard let dic = notification.userInfo as? [String:Any],
              let deliveryInfo = dic.deliveryInfo else { return }

        DispatchQueue.global(qos: .background).async {
            self.viewModel.insertInfo(info: deliveryInfo)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .passDelivery, object: nil)
    }
}

private extension FormViewController {
    
    func initUI() {
        view.backgroundColor = pinkBackground
    }
    
    func bindUI() {
        viewModel.dataSource.configureCell = { (ds, tv, ip, item) in
            switch ds[ip] {
            case let .deliberySectionItem(info):
                let cell: DeliveryCell = tv.dequeueReusableCell(for: ip)
                cell.setup(with: info, delegate: self)
                cell.indexPath = ip
                cell.contentButton.rx.tap
                    .subscribe(onNext:{ [unowned self] _ in
                        let infoVc = InfoDetailViewController()
                        let infoVm = InfoDetailViewModel()
                        infoVc.viewModel = infoVm
                        infoVc.info = info
                        infoVc.deliveryIndex = ip.row + 1
                        
                        let nav = UINavigationController(rootViewController: infoVc)
                        
                        self.present(nav, animated: true, completion: nil)
                        
                    }).disposed(by: cell.rx.disposeBag)

                return cell
            case .paymentSectionItem:
                let cell: PaymentCell = tv.dequeueReusableCell(for: ip)
                cell.backgroundColor = .white
                return cell
            case .checkSectionItem:
                return UITableViewCell()
            }
        }

        viewModel.sections
            .subscribe(onNext:{ [weak self] sections in
                self?.sections = sections
            })
            .disposed(by: rx.disposeBag)

        viewModel.sections
            .bind(to: tableView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: rx.disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: rx.disposeBag)
    }
    
    func constraintUI() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(insetDelivery(_:)),
                                               name: .passDelivery, object: nil)
    }
 
    @objc func validationAction(_ sender: UIButton) {
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! PaymentCell
        let deliverySection = tableView.headerView(forSection: 0) as! DeliveryHeaderView
        let paymentSection = tableView.headerView(forSection: 1) as! PaymentHeaderView
        let checkSection = tableView.headerView(forSection: 2) as! CheckmarkHeaderView
        var checkStatus = true
        
        let deliveryStatus = !addButtonIsHide
        let paymentStatus =  (cell.nameField.text?.isEmpty)! ||
                             (cell.phoneField.text?.isEmpty)! ||
                             (cell.emailField.text?.isEmpty)!
    
        switch checkSection.checkBox.checkState {
        case .checked:              checkStatus = false
        case .unchecked, .mixed:    checkStatus = true
        }

        let status = deliveryStatus || paymentStatus || checkStatus
        
        let deliverySelection = deliverySection.state
        let paymentSelection = paymentSection.state
        
        guard let name = cell.nameField.text,
              let phoneNumber = cell.phoneField.text,
              let email = cell.emailField.text else { return }
        
        let paymentInfo = PaymentInfo(name: name, phoneNumber: phoneNumber, email: email)
        let orderInfo = OrderInfo(deliveryType: deliverySelection,
                                  paymentType: paymentSelection,
                                  payStatus: PayStatus.notyet,
                                  businessInfo: businessA)
        let sendOrder = SendOrderModel(cartItems: viewModel.cartItems.value,
                                       totalPrice: viewModel.totalPrice.value,
                                       deliveryState: deliverySelection,
                                       paymentState: paymentSelection,
                                       paymentInfo: paymentInfo,
                                       orderInfo: orderInfo)

        switch status {
        case true:
            let alertController = UIAlertController(title: "錯誤", message: "尚有資料未填寫", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確定", style: .default)
            
            alertController.addAction(okAction)
            
            present(alertController, animated: true, completion: nil)
        case false:
            viewModel.goSendOrder(with: sendOrder)
        }
    }
    
    @objc func goInfoDetail(_ sender: UIButton) {
        let infoVc = InfoDetailViewController()
        let infoVm = InfoDetailViewModel()
        infoVc.viewModel = infoVm
        let nav = UINavigationController(rootViewController: infoVc)
        present(nav, animated: true, completion: nil)
    }
}


extension FormViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch sections[section] {
        case let .DeliverySection(title, _):
            let header = DeliveryHeaderView()
            header.setupTitle(with: title)
            header.addbutton.addTarget(self.viewModel,
                                       action: #selector(viewModel.goAddress),
                                       for: .touchUpInside)
            return header
        case let .PaymentSection(title, _):
            let header = PaymentHeaderView()
            header.setupTitle(with: title)
            return header
        case let .CheckSection(title, _):
            let header = CheckmarkHeaderView()
            header.setupTitle(with: title)
            return header
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch sections[section] {
        case .DeliverySection(_, _), .PaymentSection(_, _):
            return 80
        case .CheckSection(_, _):
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch sections[indexPath.section] {
        case .DeliverySection(_, _):
            return 75
        case .PaymentSection(_, _):
            return paymentH * 2
        case .CheckSection(_, _):
            return 0
        }
    }
}

extension FormViewController: DeliveryCellDelegate {
    func deleteDetail(at row: Int) {
        
        let alertController = UIAlertController(title: "", message: "確定要刪除嗎？", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "取消", style: .cancel)

        let okAction = UIAlertAction(title: "確定", style: .default) { _ in
            addButtonIsHide = false
            DispatchQueue.main.async {
                self.viewModel.deleteInfo(at: row)
            }
        }
        
        alertController.addAction(cancel)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
