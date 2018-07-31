//
//  IconPagingCell.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/5/23.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import Parchment
import Kingfisher

struct IconPagingCellViewModel {
    let imageUrl: URL?
    let selected: Bool
    
    init(imageUrl: URL?, selected: Bool, options: PagingOptions) {
        self.imageUrl = imageUrl
        self.selected = selected
    }
}

class IconPagingCell: PagingCell {
    
    fileprivate var viewModel: IconPagingCellViewModel?
    
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentView.addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        constraintUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        viewModel = nil
    }
    
    override func setPagingItem(_ pagingItem: PagingItem, selected: Bool, options: PagingOptions) {
        
        if let item = pagingItem as? IconItem {
            
            let viewModel = IconPagingCellViewModel(
                imageUrl: item.imageUrl,
                selected: selected,
                options: options)
            
            imageView.kf.setImage(with: viewModel.imageUrl)
            
            imageView.transform = viewModel.selected ? CGAffineTransform(scaleX: 1, y: 1)
                                                     : CGAffineTransform(scaleX: 0.5, y: 0.5)
            
            self.viewModel = viewModel
        }
        
    }
    
    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        //guard let viewModel = viewModel else { return }
        if let attributes = layoutAttributes as? PagingCellLayoutAttributes {
            let scale = (0.4 * attributes.progress) + 0.6
            imageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    private func constraintUI() {
        
        imageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(15)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
}
