//
//  CustomPageView.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/10.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import Parchment
import UIKit

extension CustomPagingViewController {
    
    var selectedIndex: Int? {
        if let selected = pageViewController.selectedViewController as? IconViewController,
            let index = viewControllers.index(of: selected) {
            return index
        }
        return nil
    }
}

class CustomPagingViewController: PagingViewController<IconItem> {

    var viewControllers = [IconViewController]()

    override init() {
        super.init()
        dataSource = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        options.menuBackgroundColor = pinkBackground!
        options.indicatorColor = pinkBackground!
        options.borderColor = .clear
        options.menuItemClass = IconPagingCell.self
        options.menuItemSize = .sizeToFit(minWidth: 100, height: 100)
        //options.menuItemSize = .fixed(width: 90, height: 90)
        options.menuItemSpacing = -20
        options.menuHorizontalAlignment = .center
        
        view = CustomPageView(
            options: options,
            collectionView: collectionView,
            pageView: pageViewController.view)
    }
    
    func configure(with viewControllers: [IconViewController]) {
        self.viewControllers.removeAll()
        self.viewControllers = viewControllers
    }
}

extension CustomPagingViewController: PagingViewControllerDataSource {
    public func numberOfViewControllers<T>(in: PagingViewController<T>) -> Int {
        return viewControllers.count
    }
    
    public func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemForIndex index: Int) -> T {
        return IconItem(name: String(viewControllers[index].foodId), index: index) as! T
    }
    
    public func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, viewControllerForIndex index: Int) -> UIViewController {
        return viewControllers[index]
    }
}

class CustomPageView: PagingView {
    override init(options: PagingOptions, collectionView: UICollectionView, pageView: UIView) {
        super.init(options: options, collectionView: collectionView, pageView: pageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        super.configure()
        pageView.makeShadow(cornerRadius: 20, shadowOpacity: 0.3, shadowOffsetW: 0.3, shadowOffsetH: 0.3)
    }
    override func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        pageView.translatesAutoresizingMaskIntoConstraints = false
        
        let metrics = [
            "height": options.menuHeight]
        
        let views = [
            "collectionView": collectionView,
            "pageView": pageView]
        
        let horizontalCollectionViewContraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[collectionView]|",
            options: NSLayoutFormatOptions(),
            metrics: metrics,
            views: views)
        
        let horizontalPagingContentViewContraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[pageView]|",
            options: NSLayoutFormatOptions(),
            metrics: metrics,
            views: views)
        
        let verticalContraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[pageView]-5-[collectionView(==height)]|",
            options: NSLayoutFormatOptions(),
            metrics: metrics,
            views: views)
        
        addConstraints(horizontalCollectionViewContraints)
        addConstraints(horizontalPagingContentViewContraints)
        addConstraints(verticalContraints)
    }
}
