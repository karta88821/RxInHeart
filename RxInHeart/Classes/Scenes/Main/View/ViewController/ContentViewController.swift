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

    // MARK : - UI
    var topView: UIView!
    var bottomView: UIView!
    let topLabel = UILabel(alignment: .left, fontSize: 18)
    var collectionView: UICollectionView!
    lazy var itemStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 5
        stackView.axis = .vertical
        return stackView
    }()
    var pushButton: UIButton!
    
    // MARK : - Properties
    var id = -1
    var items: [GiftboxItem]? {
        didSet {
            updateUI()
        }
    }
    
    // MARK : - Init
    init(id: Int, productName: String) {
        super.init(nibName: nil, bundle: nil)
        self.id = id
        topLabel.text = productName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK : - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        createViews()
        constraintUI()
    }
}


private extension ContentViewController {
    
    func createViews() {
        configureCollectionView()
        configureButton()
        addSubViewsForTopAndBottomView()
        configureView(for: view)
    }
    
    func configureCollectionView() {
        guard let items = items else { return }
        
        let totalCount = items.count
        let layout = CustomLayout()
        layout.totalCount = totalCount
        layout.spacing = 3
        layout.contentInset = 5
        
        collectionView = {
            let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
            cv.register(cellType: UICollectionViewCell.self)
            cv.dataSource = self
            cv.isScrollEnabled = false
            cv.showsVerticalScrollIndicator = false
            cv.backgroundColor = detailCollectionBg
            cv.contentInset = UIEdgeInsetsMake(5, 5, 5, 5)
            cv.layer.masksToBounds = false
            cv.layer.cornerRadius = 3
            
            return cv
        }()
    }
    
    func configureButton() {
        pushButton = {
            let button = UIButton()
            button.backgroundColor = pinkButtonBg
            button.setup(title: "Next", textColor: .white)
            button.makeShadow(cornerRadius: 15, shadowOpacity: 0.2, shadowOffsetW: 0.1, shadowOffsetH: 0.1)
            button.addTarget(self, action: #selector(toDetail), for: .touchUpInside)
            button.isAccessibilityElement = true
            return button
        }()
    }
    
    func configureView(for view: UIView) {
        view.backgroundColor = pinkBackground
        view.addSubViews(views: topView, bottomView)
    }
    
    func addSubViewsForTopAndBottomView() {
        topView = UIView(backgroundColor: pinkBackground)
        bottomView = UIView(backgroundColor: pinkBackground)
        
        topView.addSubViews(views: topLabel, pushButton)
        bottomView.addSubViews(views: collectionView, itemStackView)
    }
    
    func updateUI() {
        guard let items = items else { return }

        items.forEach { item in
            let categoryName = item.foodCategoryName
            let completeText = "\(categoryName) \(item.count)個"
            let label = UILabel(
                alignment: .left,
                fontSize: 14,
                text: completeText
            )
            itemStackView.addArrangedSubview(label)
        }
    }
    
    func constraintUI() {
        topView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        bottomView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(topView.snp.bottom)
        }
        
        topLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(30)
        }
        
        pushButton.snp.makeConstraints { make in
            make.centerY.equalTo(topLabel.snp.centerY).offset(-3)
            make.right.equalToSuperview().inset(20)
            make.width.equalTo(90)
        }
        
        collectionView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(10).priority(900)
            make.width.equalTo(180)
        }
        
        itemStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(collectionView.snp.right).offset(20)
        }
    }
    
    @objc func toDetail(_ sender: UIButton) {
        guard let productEntity = DBManager.query(ProductEntity.self, withPrimaryKey: id) else { return }
        
        switch productEntity.giftboxTypeId {
        case 0:
            print("This isn't giftBox")
        case 1, 2:
            delegate?.push(id: id)
        default:
            break
        }
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
