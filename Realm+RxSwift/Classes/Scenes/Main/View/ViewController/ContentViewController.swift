//
//  ContentViewController.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/5/3.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit

protocol ContentViewDelegate: class {
    func push(id: Int)
}

final class ContentViewController: UIViewController {
    
    // MARK : - Delegate
    weak var delegate: ContentViewDelegate?
    
    lazy var collectionView: UICollectionView = {
        guard let items = items else {return UICollectionView()}
        let totalCount = items.count
        let layout = CustomLayout()
        layout.totalCount = totalCount
        layout.spacing = 3
        layout.contentInset = 5
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.isScrollEnabled = false
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = detailCollectionBg
        cv.contentInset = UIEdgeInsetsMake(5, 5, 5, 5)
        cv.layer.masksToBounds = false
        cv.layer.cornerRadius = 3
        cv.register(cellType: UICollectionViewCell.self)
        return cv
    }()
    
    lazy var button: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = pinkButtonBg
        btn.setup(title: "Next", textColor: .white)
        btn.makeShadow(cornerRadius: 15, shadowOpacity: 0.2, shadowOffsetW: 0.1, shadowOffsetH: 0.1)
        btn.addTarget(self, action: #selector(toDetail), for: .touchUpInside)
        return btn
    }()
    
    // MARK : - UI
    let topView = UIView()
    let buttomView = UIView()
    let topLabel = UILabel()
    let itemStackView = UIStackView()
    
    // MARK : - Properties
    var id = -1
    
    var items: [GiftboxItem]? {
        didSet {
            updateUI()
        }
    }
    
    var productName: String? {
        didSet {
            topLabel.text = productName
        }
    }
    
    // MARK : - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        constraintUI()
    }
}


private extension ContentViewController {
    
    func initUI() {
        view.backgroundColor = pinkBackground
        buttomView.backgroundColor = pinkBackground
        topView.backgroundColor = pinkBackground
        topLabel.setup(textAlignment: .left, fontSize: 18, textColor: grayColor)
    
        view.addSubViews(views: topView, buttomView)
        topView.addSubViews(views: topLabel, button)
        buttomView.addSubViews(views: collectionView, itemStackView)

        itemStackView.spacing = 5
        itemStackView.axis = .vertical
    }
    
    func updateUI() {
        
        guard let items = items else { return }
        
        items.forEach { item in
            let label = UILabel()
            let categoryName = item.foodCategoryName
            
            let completeText = "\(categoryName) \(item.count)個"
            label.setupWithTitle(textAlignment: .left, fontSize: 14, textColor: grayColor, text: completeText)
            
            itemStackView.addArrangedSubview(label)
        }
    }
    
    func constraintUI() {
        topView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        buttomView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(topView.snp.bottom)
        }
        
        topLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(30)
        }
        
        button.snp.makeConstraints { make in
            make.centerY.equalTo(topLabel.snp.centerY).offset(-3)
            make.right.equalToSuperview().inset(20)
            make.width.equalTo(90)
        }
        
        collectionView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(10)
            make.width.equalTo(180)
        }
        
        itemStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(collectionView.snp.right).offset(20)
        }
    }
    
    @objc func toDetail(_ sender: UIButton) {
        delegate?.push(id: id)
    }
}

extension ContentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath)
        cell.backgroundColor = pinkCvCellBackground
        cell.layer.masksToBounds = false
        cell.layer.cornerRadius = 3
        return cell
    }
}
