//
//  CustomLayout.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/7/14.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit

class CustomLayout : UICollectionViewLayout {
    
    private let leftCount: Int = 3
    var spacing: CGFloat = 10
    var contentInset: CGFloat = 10
    
    var totalCount: Int!
    
    // 内容區域總大小
    override var collectionViewContentSize: CGSize {
        let width = collectionView!.bounds.size.width - collectionView!.contentInset.left
            - collectionView!.contentInset.right
        return CGSize(width: width, height: CGFloat(collectionView!.bounds.size.height))
    }
    
    // 所有item的位置屬性
    override func layoutAttributesForElements(in rect: CGRect)
        -> [UICollectionViewLayoutAttributes]? {
            var attributesArray = [UICollectionViewLayoutAttributes]()
            let cellCount = self.collectionView!.numberOfItems(inSection: 0)
            for i in 0..<cellCount {
                let indexPath =  IndexPath(item:i, section:0)
                let attributes =  self.layoutAttributesForItem(at: indexPath)
                attributesArray.append(attributes!)
            }
            return attributesArray
    }
    
    // 回傳每个item的位置和大小
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
            
            let attribute =  UICollectionViewLayoutAttributes(forCellWith:indexPath)

            let constantWidth = (collectionViewContentSize.width - spacing) / 2
            let constantHeight = collectionViewContentSize.height
            
            let rightCount = totalCount - leftCount
            
            let leftHeight = (constantHeight - contentInset * 2 - spacing * 2) / CGFloat(leftCount)
            let rightHeight = (constantHeight - contentInset * 2 - spacing *  CGFloat(rightCount - 1)) / CGFloat(rightCount)
            
            
            if indexPath.item < leftCount {
                if indexPath.item == 0 {
                    attribute.frame = CGRect(x:0,
                                             y:0 + (leftHeight * CGFloat(indexPath.item)) ,
                                             width:constantWidth,
                                             height:leftHeight)
                } else {
                    attribute.frame = CGRect(x:0,
                                             y:0 + ((leftHeight + spacing) * CGFloat(indexPath.item)) ,
                                             width:constantWidth,
                                             height:leftHeight)
                }
            } else {
                let rightYoffset = (rightHeight + spacing * CGFloat(indexPath.item - 3))  * CGFloat(indexPath.item - 3)
                
                attribute.frame = CGRect(x: constantWidth + spacing,
                                         y: 0 + rightYoffset,
                                         width: constantWidth,
                                         height: rightHeight)
            }
        
            return attribute
    }
    
    /*
     //如果有页眉、页脚或者背景，可以用下面的方法实现更多效果
     func layoutAttributesForSupplementaryViewOfKind(elementKind: String!,
     atIndexPath indexPath: NSIndexPath!) -> UICollectionViewLayoutAttributes!
     func layoutAttributesForDecorationViewOfKind(elementKind: String!,
     atIndexPath indexPath: NSIndexPath!) -> UICollectionViewLayoutAttributes!
     */
}
