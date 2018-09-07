//
//  FoodsFlowLayout.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/6/26.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit

class FoodsFlowLayout: UICollectionViewFlowLayout {
    
    // here you can define the height of each cell
    let itemHeight: CGFloat = 120
    let spacing: CGFloat = 10
    
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }

    func setupLayout() {
        minimumInteritemSpacing = 1
        minimumLineSpacing = 1
        scrollDirection = .vertical
        sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    /// here we define the width of each cell, creating a 2 column layout. In case you would create 3 columns, change the number 2 to 3
    func itemWidth() -> CGFloat {
        let collectionWidth = collectionView!.frame.width
        let totalItemWidth = collectionWidth - spacing * 2
        return totalItemWidth / 4
    }
    
    override var itemSize: CGSize {
        set {
            self.itemSize = CGSize(width: itemWidth(), height: itemHeight)
        }
        get {
            return CGSize(width: itemWidth(), height: itemHeight)
        }
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return collectionView!.contentOffset
    }
    
}
