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

final class MainTableViewCell: UITableViewCell, Reusable {
    
    var product: ProductPresentable? {
        didSet {
            updateUI()
        }
    }

    // MARK: - UI
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [topView, expandableView])
        stack.axis = .vertical
        stack.spacing = 0
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    var topView: UIView!
    let labelView = UIView(backgroundColor: .white)
    var expandableView: UIView!
    var titleIconImageView: UIImageView!
    let productTypeNameLabel = UILabel(alignment: .left, fontSize: 18, textColor: darkRed)
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = (screenWidth - 45) / 2
        let itemHight: CGFloat = 210 - 50
        layout.itemSize = CGSize(
            width: itemWidth,
            height: itemHight
        )
        layout.sectionInset = UIEdgeInsets(
            top: -10,
            left: 15,
            bottom: 0,
            right: 15
        )
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        
        let cv = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        cv.backgroundColor = .white
        cv.showsHorizontalScrollIndicator = false
        cv.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "MainCollectionViewCell")
        return cv
    }()
    let path = UIBezierPath()

    private(set) var disposeBag = DisposeBag()
    
    // MARK: - Properties
    var products = Variable<[ProductEntity]>([])
    var viewControllers: [ContentViewController]!
    var itemHasBeenSelected = false 
    
    // MARK : - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createViews()
        configureCell()
        constraintUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createViews()
        configureCell()
        constraintUI()
    }
    
    func makeTriangle() {
        let width = collectionView.width / 4
        path.move(to: CGPoint(x: width - 20, y: collectionView.height))
        path.addLine(to: CGPoint(x: width, y: collectionView.height - 20))
        path.addLine(to: CGPoint(x: width + 20, y: collectionView.height))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        products.value = []
        viewControllers = []
    }
    
    func setupCollectionView(with caseModels: Observable<[CasePresentable]>, and tag: Int) {
        caseModels
            .bind(to: collectionView.rx.items(cellIdentifier: "MainCollectionViewCell", cellType: MainCollectionViewCell.self)) { (row, element, cell) in
                cell.caseModel = element
            }
            .disposed(by: disposeBag)
        
        collectionView.tag = tag
    }
    
    func setupPageView(with productEnties: [ProductEntity]) {
        
        expandableView.subviews.forEach{$0.removeFromSuperview()}
        
        let style = DNSPageStyle()
        style.isShowBottomLine = true
        style.isTitleScrollEnable = true
        style.titleViewBackgroundColor = UIColor.clear
        
        let titles = productEnties.map{$0.name}
        
        let childViewControllers: [ContentViewController] = productEnties.map { product -> ContentViewController in
            let controller = ContentViewController(id: product.id, productName: product.name)
            controller.items = Array(product.items)
            return controller
        }
        
        self.viewControllers = childViewControllers
        
        let manager = DNSPageViewManager(
            style: style,
            titles: titles,
            childViewControllers: childViewControllers
        )
        
        expandableView.addSubview(manager.contentView)
        
        manager.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    func expandView() {
        if itemHasBeenSelected == false {
            itemHasBeenSelected = true
            expandableView.isHidden = false
        } else {
            
        }
    }

}

private extension MainTableViewCell {
    
    func createViews() {
        configureImageView()
        configureTopView()
        configureExpandedView()
        configureContentView()
    }
    
    func updateUI() {
        guard let product = product else { return }
        productTypeNameLabel.text = product.productTypeName
    }
    
    func configureContentView() {
        contentView.addSubview(stackView)
        topView.addSubViews(views: labelView, collectionView)
        labelView.addSubViews(views: titleIconImageView, productTypeNameLabel)
    }
    
    func configureImageView() {
        titleIconImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "giftcard")
            return imageView
        }()
    }
    
    func configureTopView() {
        topView = UIView(backgroundColor: .white)
    }
    
    func configureExpandedView() {
        expandableView = {
            let view = UIView(backgroundColor: .white)
            view.isHidden = true
            return view
        }()
    }
    
    func configureCell() {
        selectionStyle = .none
        clipsToBounds = true
    }

    func constraintUI() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        topView.snp.makeConstraints{
            $0.height.equalTo(210).priority(750)
        }

        expandableView.snp.makeConstraints {
            $0.height.equalTo(170).priority(750)
        }
        
        labelView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(50).priority(999)
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
    
}
