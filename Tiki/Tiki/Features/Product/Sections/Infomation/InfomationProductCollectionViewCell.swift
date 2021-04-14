//
//  InfomationProductCollectionViewCell.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/13/21.
//

import UIKit
import FSPagerView

class InfomationProductCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Variables
    
    var product: Product?
    
    // MARK: - UI Elements
    
    fileprivate lazy var pageView: FSPagerView = {
        let view = FSPagerView()
        view.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        view.itemSize = FSPagerView.automaticSize
        view.transformer = FSPagerViewTransformer(type: .zoomOut)
        view.automaticSlidingInterval = 6.0
        view.layer.cornerRadius = Dimension.shared.conerRadiusMedium
        view.layer.masksToBounds = true
        view.isInfinite = true
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    fileprivate lazy var pageControl: FSPageControl = {
        let view = FSPageControl()
        view.contentHorizontalAlignment = .center
        view.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return view
    }()
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
    }
    
    // MARK: - Helper Method
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutPageView() {
        addSubview(pageView)
        pageView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(500)
        }
    }
    
    private func layoutPageControl() {
        pageView.addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(Dimension.shared.pageControlHeight)
        }
    }
    
}

extension InfomationProductCollectionViewCell: FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return product?.photos.count ?? 0
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let imageURL = product?.photos[index].url
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.sd_setImage(with: imageURL?.url, completed: nil)
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        return cell
    }
}

extension InfomationProductCollectionViewCell: FSPagerViewDelegate {
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pageControl.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.pageControl.currentPage = pagerView.currentIndex
    }
}

