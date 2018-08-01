//
//  DeliveryCell.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/2.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import SnapKit
import Reusable

protocol DeliveryCellDelegate: class {
    func deleteDetail(at row: Int)
}

class DeliveryCell: UITableViewCell, Reusable {
    
    // MARK : - UI
    let addressIndexLabel = UILabel()
    let addressLabel = UILabel()
    let contentButton = UIButton()
    let deleteButton = UIButton()

    weak var delegate: DeliveryCellDelegate?
    
    var indexPath: IndexPath! {
        didSet {
            guard let indexPath = indexPath else { return }
            addressIndexLabel.text = "地址\(indexPath.row + 1)"
        }
    }
    
    // MARK : - Initialization
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initUI()
    }
    
    func setup(with viewModel: DeliveryInfo, delegate: DeliveryCellDelegate) {
        addressLabel.text = viewModel.address
        self.delegate = delegate
    }
    
    // MARK : - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        constraintUI()
    }
}

private extension DeliveryCell {
    func initUI() {
        selectionStyle = .none
        backgroundColor = .white
        addressIndexLabel.setup(textAlignment: .left, fontSize: 14, textColor: textFieldTitleColor)
        addressLabel.setup(textAlignment: .left, fontSize: 20, textColor: grayColor)
        let deleteString = NSAttributedString(string: "X", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .medium), .foregroundColor: UIColor.black])
        let contentString = NSAttributedString(string: "內容", attributes: [.font: UIFont.systemFont(ofSize: 18), .foregroundColor: darkRed!])
    
        contentButton.setAttributedTitle(contentString, for: .normal)
        deleteButton.setAttributedTitle(deleteString, for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteAction(_:)), for: .touchUpInside)
        
        addSubViews(views: addressIndexLabel, addressLabel, contentButton, deleteButton)
    }
    
    func constraintUI() {

        addressLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(5)
            $0.left.equalToSuperview().offset(30)
        }
        
        addressIndexLabel.snp.makeConstraints {
            $0.bottom.equalTo(addressLabel.snp.top)
            $0.left.equalTo(addressLabel.snp.left).offset(-5)
        }
        
        deleteButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
        }
        
        contentButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(deleteButton.snp.left).offset(-15)
        }
    }
    
    @objc func deleteAction(_ sender: UIButton) {
        delegate?.deleteDetail(at: indexPath.row)
    }
}

