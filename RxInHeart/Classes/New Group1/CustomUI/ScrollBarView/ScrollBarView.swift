//
//  ScrollBarView.swift
//  Realm+RxSwift
//
//  Created by liao yuhao on 2018/4/17.
//  Copyright © 2018年 liao yuhao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import TYCyclePagerView
import Kingfisher
import SnapKit

class ScrollBarView: UIView {
    
    var picArr = Variable<[String]>([])
    
    lazy var pagerView: TYCyclePagerView = {
        let pager = TYCyclePagerView()
        pager.isInfiniteLoop = true
        pager.autoScrollInterval = 3.0
        return pager
    }()
    
    lazy var pageControl: TYPageControl = {
        let control = TYPageControl()
        control.currentPageIndicatorSize = CGSize(width: 8, height: 8)
        control.contentHorizontalAlignment = .right
        control.contentInset = UIEdgeInsetsMake(0, 0, 0, 16)
        return control
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        bindUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ScrollBarView {
    
    private func initUI() {
        
        pagerView.addSubview(pageControl)
        self.addSubview(pagerView)
        
        pagerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints { make in
            make.height.equalTo(26)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-8)
            make.left.equalToSuperview().offset(8)
        }
        
        pagerView.register(UINib(nibName: String(describing: ScrollBarCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ScrollBarCell.self))
        
        pagerView.delegate = self
        pagerView.dataSource = self
    }
    
    func bindUI() {
        
        picArr.asObservable().subscribe { (_) in
            self.pagerView.reloadData()
            self.pageControl.numberOfPages = self.picArr.value.count
            }
        .disposed(by: rx.disposeBag)
    }
}

extension ScrollBarView: TYCyclePagerViewDataSource, TYCyclePagerViewDelegate  {
    
    func numberOfItems(in pageView: TYCyclePagerView) -> Int {
        return picArr.value.count
    }
    
    func layout(for pageView: TYCyclePagerView) -> TYCyclePagerViewLayout {
        
        let layout = TYCyclePagerViewLayout()
        layout.itemSize = CGSize(width: pageView.frame.width, height: pageView.frame.height)
        layout.itemSpacing = 0
        layout.itemHorizontalCenter = true
        
        return layout
    }
    
    func pagerView(_ pagerView: TYCyclePagerView, cellForItemAt index: Int) -> UICollectionViewCell {
        
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "ScrollBarCell", for: index) as! ScrollBarCell
        cell.imageView.kf.setImage(with: URL(string: picArr.value[index]))
        
        return cell
    }
    
    func pagerView(_ pageView: TYCyclePagerView, didScrollFrom fromIndex: Int, to toIndex: Int) {
        pageControl.currentPage = toIndex
    }
}
