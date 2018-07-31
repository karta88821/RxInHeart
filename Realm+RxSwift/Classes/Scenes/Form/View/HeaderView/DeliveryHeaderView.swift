//
//  DeliveryHeaderView.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/2.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit

enum DeliveryState: String {
    case homedelivery = "宅配"
    case getBySelf = "自取"
    
    func getString() -> String {
        switch self {
        case .homedelivery:
            return DeliveryState.homedelivery.rawValue
        case .getBySelf:
            return DeliveryState.getBySelf.rawValue
        }
    }
}

class DeliveryHeaderView: BaseHeader {
    
    let addbutton = UIButton()
    //let title: BaseTitle = .delivery
    var state: DeliveryState = .homedelivery
    
    private let deliverys: [DeliveryState] = [.homedelivery, .getBySelf]

    var isHide: Bool? {
        didSet {
            if let _isHide = isHide {
                addbutton.isHidden = _isHide
            }
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initUI()
    }
     
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        constraintUI()
    }

}

private extension DeliveryHeaderView {
    
    func initUI() {
        
        let attributeString = NSAttributedString(string: "+新增地址", attributes: [.font: UIFont.systemFont(ofSize: 15),.foregroundColor: darkRed!])
        
        //titleLabel.text = title.rawValue
        
        dropButton.setup(title: state.rawValue, textColor: .black)
        dropDown.dataSource = deliverys.map{$0.getString()}
        
        isHide = addButtonIsHide
        addbutton.setAttributedTitle(attributeString, for: .normal)
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.dropButton.setTitle(item, for: .normal)
            if let selectedState = self?.deliverys[index] {
                self?.state = selectedState
            }
        }
        contentView.addSubview(addbutton)
    }
    
    func constraintUI() {
        addbutton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(10)
        }
    }
}
