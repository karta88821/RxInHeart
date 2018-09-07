//
//  InfoDetailViewController.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/8.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import SnapKit

class InfoDetailViewController: UIViewController {
    
    // MARK : - UI
    var tableView: UITableView!
    
    // MARK : - ViewModel
    var viewModel: InfoDetailViewModel!
    
    // MARK : - Properties
    var info: DeliveryInfo! {
        didSet {
            updateDeliveryTexts()
        }
    }
    
    var deliveryIndex: Int!
    var deliveryTexts:[String] = []
    var sections: [SectionTypes]!
    private let deliveryTitles = ["收貨人姓名","收貨人聯絡電話","收貨人地址"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView(for: view)
        configureSections()
        constraintUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureNavigationBarItem()
    }
    
    @objc func dismiss(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateDeliveryTexts() {
        if deliveryTexts.count != 0 {
            deliveryTexts.removeAll()
        }
        deliveryTexts.append(contentsOf: [info.name, info.phone, info.address])
    }
}

private extension InfoDetailViewController {
    
    func createViews() {
        configureTableView()
    }
    
    func configureView(for view: UIView) {
        createViews()
        view.addSubview(tableView)
    }
    
    func configureTableView() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
        headerView.backgroundColor = pinkBackground
        let headerLabel = UILabel(alignment: .left, fontSize: 20, text: "內容")
        headerView.addSubview(headerLabel)
        
        headerLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(20)
        }
        
        tableView = {
            let tv = UITableView(frame: .zero)
            tv.showsVerticalScrollIndicator = false
            tv.backgroundColor = pinkBackground
            tv.tableHeaderView = headerView
            tv.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
            tv.separatorStyle = .none
            tv.dataSource = self
            tv.delegate = self
            tv.register(cellType: InfoDeliveryCell.self)
            tv.register(cellType: InfoProductCell.self)
            
            return tv
        }()
    }
    
    func configureNavigationBarItem() {
        if let navigationBarItem = navigationController?.navigationBar.items?[0] {
            let button = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismiss(_:)))
            navigationBarItem.setLeftBarButton(button, animated: true)
        }
    }
    
    func configureSections() {
        let vcType: VcTypes = .infoDetail
        sections = vcType.getSectionTypes()
    }
    
    func constraintUI() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension InfoDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .deliveryInfo:
            return 3
        case .allocateInfo:
            return info.deliveryInfoCartItems.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .deliveryInfo:
            let cell = tableView.dequeueReusableCell(for: indexPath) as InfoDeliveryCell
            cell.infoText = deliveryTexts[indexPath.row]
            cell.title = deliveryTitles[indexPath.row]
            return cell
        case .allocateInfo:
            let cell = tableView.dequeueReusableCell(for: indexPath) as InfoProductCell
            cell.cartItem = info.deliveryInfoCartItems[indexPath.row]
            return cell
        }
    }
}

extension InfoDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section] {
        case .deliveryInfo:
            return 80
        case .allocateInfo:
            return 150
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let baseHeader = InfoHeaderView()
        
        switch sections[section] {
        case .deliveryInfo:
            if (deliveryIndex) != nil {
                baseHeader.titleLabel.text = "地址\(deliveryIndex!)"
                return baseHeader
            }
        case .allocateInfo:
            baseHeader.titleLabel.text = "商品資訊"
            return baseHeader
        }
        return nil
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
}
