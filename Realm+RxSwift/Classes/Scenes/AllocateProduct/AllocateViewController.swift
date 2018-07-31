//
//  AllocateViewController.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/4.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import SnapKit
import RxFlow

var addButtonIsHide = false

class AllocateViewController: UIViewController {
    
    // MARK : - ViewModel
    var viewModel: AllocateViewModel!
    
    // MARK : - UI
    let button = UIButton()
    var tableView: UITableView!
    var popupView: PopupView!
    let backgroundButton = UIButton()
    
    // MARK : - Properties
    var deliveryInfo: DeliveryInfo!

    private let footerText = "備註：最低宅配量12盒起跳。"
    private let cellId = "AllocateCell"
    private var limitCount = 12
    
    // MARK : - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        bindUI()
        constraintUI()
    }
}

private extension AllocateViewController {
    func initUI() {
        
        let headerView = AllocateHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 120))

        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        footerView.backgroundColor = .white
        let footerLabel = UILabel()
        footerLabel.setupWithTitle(textAlignment: .left, fontSize: 20, textColor: .lightGray, text: footerText)
        footerView.addSubview(footerLabel)
        footerLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(20)
            $0.width.equalTo(270)
        }
        
        let tableView = UITableView(frame: .zero)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .white
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = footerView
        tableView.separatorStyle = .singleLine
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        tableView.register(AllocateCell.self, forCellReuseIdentifier: cellId)
        self.tableView = tableView

        button.makeRetagle(with: "確定")
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        
        backgroundButton.backgroundColor = .black
        backgroundButton.alpha = 0
        backgroundButton.addTarget(self, action: #selector(dismissView(_:)), for: .touchUpInside)
        
        popupView = PopupView(type: .allocate)

        view.addSubViews(views: button, self.tableView, backgroundButton)
        view.insertSubview(popupView, aboveSubview: backgroundButton)
        view.backgroundColor = .white
    }
    
    func bindUI() {
        
        viewModel.products
            .subscribe(onNext:{ [unowned self] products in
                let idArray = products.map{$0.id!}
                infoManager.setCurrentIdArray(with: idArray)
                infoManager.configureCountList()
                
                self.viewModel.products
                    .bind(to: self.tableView.rx.items(cellIdentifier: self.cellId, cellType: AllocateCell.self)) { [weak self]row, item, cell in
                        let indexPath = IndexPath(row: row, section: 0)
                        let selectedCount = infoManager.getcountList()[indexPath.row]
                        cell.setupUI(cartItem: item, selectedCount: selectedCount)
                        cell.delegate = self
                    }
                    .disposed(by: self.rx.disposeBag)
            })
            .disposed(by: rx.disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: rx.disposeBag)
    }
    
    @objc func dismissView(_ sender: Any) {
        popupView.snp.updateConstraints {
            $0.centerY.equalToSuperview().offset(1000)
        }
        self.backgroundButton.alpha = 0
    }

    func constraintUI() {
        
        tableView.snp.makeConstraints {
            $0.bottom.equalTo(button.snp.top).offset(-30)
            $0.left.top.right.equalToSuperview()
        }

        button.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-30)
            $0.width.equalTo(180)
            $0.height.equalTo(40)
        }
    
        popupView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(1000)
            $0.left.right.equalToSuperview().inset(30)
            $0.height.equalTo(50)
        }
        
        backgroundButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc func buttonAction(_ sender: AnyObject) {
        
        if (deliveryInfo.deliveryInfoCartItems.count != 0) {
            
            if let cells = tableView.visibleCells as? [AllocateCell] {
                let enables = cells.map{($0.totalCount - $0.selectedCount == 0)}
                addButtonIsHide = enables.contains(false) ? false : true
            }

            NotificationCenter.default.post(name: .passDelivery,
                                            object: self,
                                            userInfo: ["deliveryInfo": deliveryInfo])
            dismiss()
        } else {
            let alert = UIAlertController(title: "錯誤", message: "至少選擇一樣", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確定", style: .cancel, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }

    }

}

extension AllocateViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! AllocateCell
        
        guard let frameSizess = cell.frameSizes else {
            return
        }
        
        let alert = UIAlertController(style: .alert, title: "選取商品", message: "")
        alert.setTitle(font: UIFont.systemFont(ofSize: 18, weight: .light), color: .black)
        
        let pickerViewValues: [[String]] = [frameSizess.map { Int($0).description }]
        
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: frameSizess.index(of: CGFloat(cell.selectedCount)) ?? 0)
        
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            
            cell.selectedCount = Int(frameSizess[index.row])
        }
        
        alert.addAction(title: "選取",style: .default) { [weak self] _ in
            
            cell.countLabel.text = "\(cell.selectedCount)/\(cell.newTotal)"
            
            if let cellCartItem = cell.item , cell.selectedCount != 0 {
                let deliveryInfoCartItem = DeliveryInfoCartItem(cartItem: cellCartItem, count: cell.selectedCount)
                self?.deliveryInfo.deliveryInfoCartItems.append(deliveryInfoCartItem)
            }
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension AllocateViewController: PopViewPresentable {
    func showPopup(item: CartItem?, deliveryInfo: DeliveryInfo?) {
        
        guard let item = item else { return }
        
        popupView.setupAllocate(with: item)
        
        var contentH: CGFloat = CGFloat(50 + (item.pickedItem.count * 45))
        
        if contentH > 800 {
            contentH = 800
        }
        
        popupView.snp.updateConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(contentH)
        }
        
        self.backgroundButton.alpha = 0.3
    }
}

extension AllocateViewController: Stepper {
    @objc public func dismiss() {
        self.step.accept(InHeartStep.dismissAddress)
    }
}


