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
    
    // MARK : - UI
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero)
        tv.showsVerticalScrollIndicator = false
        tv.backgroundColor = .white
        tv.tableHeaderView = headerView
        tv.tableFooterView = footerView
        tv.separatorStyle = .singleLine
        tv.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        tv.register(AllocateCell.self, forCellReuseIdentifier: cellId)
        return tv
    }()
    
    lazy var headerView: UIView = {
        let header = AllocateHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 120))
        return header
    }()
    
    lazy var footerView: UIView = {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        footer.backgroundColor = .white
        let label = UILabel(alignment: .left, fontSize: 20, textColor: .lightGray, text: footerText)
        footer.addSubview(label)
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(20)
            $0.width.equalTo(270)
        }
        return footer
    }()
    
    let button = UIButton()
    var popupView: PopupView!
    let backgroundButton = UIButton()
    
    // MARK : - ViewModel
    var viewModel: AllocateViewModel!
    
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
        configureButton(for: button)
    }
    
    private func configureButton(for button: UIButton) {
        button.makeRetagle(with: "確定")
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }
}

private extension AllocateViewController {
    func initUI() {
        
        backgroundButton.backgroundColor = .white
        backgroundButton.alpha = 0
        backgroundButton.addTarget(self, action: #selector(dismissView(_:)), for: .touchUpInside)
        
        popupView = PopupView(type: .allocate)

        view.addSubViews(views: button, tableView, backgroundButton)
        view.insertSubview(popupView, aboveSubview: backgroundButton)
        view.backgroundColor = .white
    }
    
    func bindUI() {
        
        viewModel.products
            .subscribe(onNext:{ [unowned self] products in
                let idArray = products.map{$0.id}
                infoManager.setCurrentIdArray(with: idArray)
                infoManager.configureCountList()
                
                self.viewModel.products
                    .bind(to: self.tableView.rx.items(cellIdentifier: self.cellId, cellType: AllocateCell.self)) { [weak self]row, item, cell in
                        let selectedCount = infoManager.getcountList()[row]
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
        self.backgroundButton.alpha = 0
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut], animations: {
            self.popupView.snp.updateConstraints {
                $0.centerY.equalToSuperview().offset(1000)
            }
        }, completion: nil)
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
        
        backgroundButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let popWidth = screenWidth - 40
        popupView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(1000)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(popWidth)
            $0.height.equalTo(100)
        }
        

    }
    
    @objc func buttonAction(_ sender: AnyObject) {
        
        if (deliveryInfo.deliveryInfoCartItems.count != 0) {
            
            guard let cells = tableView.visibleCells as? [AllocateCell],
                  let deliveryInfo = deliveryInfo else { return }

            let enables = cells.map{($0.totalCount - $0.selectedCount == 0)}
            addButtonIsHide = enables.contains(false) ? false : true

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
        
        guard let frameSizess = cell.frameSizes else { return }
        
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
        self.backgroundButton.alpha = 0.6

        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut], animations: {
            self.popupView.snp.updateConstraints {
                $0.centerY.equalToSuperview()
                $0.height.equalTo(contentH)
            }
        }, completion: nil)    
    }
}

extension AllocateViewController: Stepper {
    @objc public func dismiss() {
        self.step.accept(InHeartStep.dismissAddress)
    }
}


