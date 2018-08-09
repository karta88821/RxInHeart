//
//  MainTableViewCell.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/2/13.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DNSPageView
import SnapKit
import Reusable

final class MainTableViewCell: UITableViewCell {
    
    var product: ProductPresentable? {
        didSet {
            updateUI()
        }
    }

    // MARK: - UI
    let stackView = UIStackView()
    let topView = UIView()
    let labelView = UIView()
    let bottomView = UIView()
    let titleIconImageView = UIImageView()
    let productTypeNameLabel = UILabel()
    
    var collectionView: UICollectionView!

    private(set) var disposeBag = DisposeBag()
    
    // MARK: - Properties
    var products = Variable<[Product]>([])
    var caseModels = Variable<[CasePresentable]>([])
    var viewControllers: [ContentViewController]!
    
    // MARK : - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
        constraintUI()
        setupPageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initUI()
        constraintUI()
        setupPageView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
//        product = nil
//        products.value = []
//        viewControllers = []
    }
}

private extension MainTableViewCell {
    
    func updateUI() {
        guard let product = product else { return }
        productTypeNameLabel.text = product.productTypeName
    }
    
    func initUI() {
        
        let layout = UICollectionViewFlowLayout()
        let itemWidth = (screenWidth - 45) / 2
        let itemHight: CGFloat = 210 - 50
        layout.itemSize = CGSize(width: itemWidth, height: itemHight)
        layout.sectionInset = UIEdgeInsets(top: -10, left: 15, bottom: 0, right: 15)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout )
        cv.backgroundColor = .white
        cv.showsHorizontalScrollIndicator = false
        cv.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "MainCollectionViewCell")
        cv.delegate = nil
        cv.dataSource = nil
        self.collectionView = cv
        
        
        selectionStyle = .none
        clipsToBounds = true
        
        stackView.axis = .vertical
        stackView.spacing = 0
        topView.backgroundColor = .white
        labelView.backgroundColor = .white
        titleIconImageView.contentMode = .scaleAspectFit
        titleIconImageView.image = UIImage(named: "giftcard")
        productTypeNameLabel.setup(textAlignment: .left, fontSize: 18, textColor: darkRed)

        contentView.addSubview(stackView)
        stackView.insertArrangedSubview(topView, at: 0)
        stackView.insertArrangedSubview(bottomView, at: 1)
        topView.addSubViews(views: labelView, collectionView)
        labelView.addSubViews(views: titleIconImageView, productTypeNameLabel)
    }
    
    func constraintUI() {
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        topView.snp.makeConstraints{
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(210).priority(999)
        }
        
        labelView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(50).priority(900)
        }
        
        titleIconImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
            $0.height.equalTo(20)
        }
        
        productTypeNameLabel.snp.makeConstraints{
            $0.centerY.equalTo(titleIconImageView.snp.centerY)
            $0.left.equalTo(titleIconImageView.snp.right).offset(-10)
        }
        
        collectionView.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.top.equalTo(labelView.snp.bottom)
        }
    }
    
    func setupPageView() {
        
        let style = DNSPageStyle()
        style.isShowBottomLine = true
        style.isTitleScrollEnable = true
        style.titleViewBackgroundColor = UIColor.clear
        
        products.asObservable()
            .subscribe(onNext:{ [weak self] products in
                guard let `self` = self else { return }
                
                let titles = products.map{$0.name}
                
                let childViewControllers: [ContentViewController] = products.map { product -> ContentViewController in
                    let controller = ContentViewController(id: product.id, productName: product.name)
                    controller.items = product.items
                    return controller
                }
                
                self.viewControllers = childViewControllers
                let manager = DNSPageViewManager(style: style, titles: titles, childViewControllers: childViewControllers)
                
                self.bottomView.addSubview(manager.contentView)
                
                manager.contentView.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview()
                }
            })
            .disposed(by: disposeBag)
        
        caseModels.asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: "MainCollectionViewCell", cellType: MainCollectionViewCell.self)) { row, item, cell in
                cell.caseModel = item
            }
            .disposed(by: disposeBag)
    }
}
