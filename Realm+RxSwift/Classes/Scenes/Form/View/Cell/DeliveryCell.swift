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
    var addressIndexLabel: UILabel!
    var addressLabel: UILabel!
    var contentButton: UIButton!
    var deleteButton: UIButton!

    // MARK : - Delegate
    weak var delegate: DeliveryCellDelegate?
    
    // MARK : - Property
    var indexPath: IndexPath! {
        didSet {
            guard let indexPath = indexPath else { return }
            addressIndexLabel.text = "地址\(indexPath.row + 1)"
        }
    }
    
    // MARK : - Initialization
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView(for: self)
        constraintUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView(for: self)
        constraintUI()
    }
    
    func setup(with viewModel: DeliveryInfo, delegate: DeliveryCellDelegate) {
        addressLabel.text = viewModel.address
        self.delegate = delegate
    }
    
    @objc func deleteAction(_ sender: UIButton) {
        delegate?.deleteDetail(at: indexPath.row)
    }
}

private extension DeliveryCell {
    
    func createViews() {
        configureLabels()
        configureButtons()
    }
    
    func configureView(for view: UIView) {
        createViews()
        addSubViews(views: addressIndexLabel, addressLabel, contentButton, deleteButton)
    }
    
    func configureLabels() {
        addressIndexLabel = UILabel(alignment: .left, fontSize: 14, textColor: textFieldTitleColor)
        addressLabel = UILabel(alignment: .left, fontSize: 20)
    }
    
    func configureButtons() {
        let deleteString = NSAttributedString(string: "X", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .medium), .foregroundColor: UIColor.black])
        let contentString = NSAttributedString(string: "內容", attributes: [.font: UIFont.systemFont(ofSize: 18), .foregroundColor: darkRed!])
        
        contentButton = {
            let button = UIButton()
            button.setAttributedTitle(contentString, for: .normal)
            return button
        }()
        
        deleteButton = {
            let button = UIButton()
            button.setAttributedTitle(deleteString, for: .normal)
            button.addTarget(self, action: #selector(deleteAction(_:)), for: .touchUpInside)
            return button
        }()
    }
    
    func configureCell() {
        selectionStyle = .none
        backgroundColor = .white
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
}

