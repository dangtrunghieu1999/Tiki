//
//  BannerCollectionViewCell.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/2/21.
//

import UIKit
import FSPagerView

class BannerCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Elements
    
    var banners: [Banner] = []
    
    fileprivate lazy var topView: BaseView = {
        let view = BaseView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    private var bannerShimmerView: BaseShimmerView = {
        let view = BaseShimmerView()
        view.isHidden = true
        return view
    }()
    
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
        layoutTopView()
        layoutBannerShimmerView()
        layoutPageView()
        layoutPageControl()
        startShimmering()
    }
    
    // MARK: - Helper Method

    func startShimmering() {
        bannerShimmerView.startShimmer()
        topView.isHidden = true
        bannerShimmerView.isHidden = false
    }
    
    func stopShimmering() {
        bannerShimmerView.stopShimmer()
        topView.isHidden = false
        bannerShimmerView.isHidden = true
    }
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutTopView() {
        addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
                .inset(dimension.mediumMargin_12)
            make.top.bottom.equalToSuperview()
                .inset(dimension.mediumMargin_12)
        }
    }
    
    private func layoutBannerShimmerView() {
        addSubview(bannerShimmerView)
        bannerShimmerView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(topView)
        }
    }
    
    private func layoutPageView() {
        topView.addSubview(pageView)
        pageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func layoutPageControl() {
        pageView.addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.right.equalTo(pageView)
            make.height.equalTo(dimension.pageControlHeight)
        }
    }

    func configCell(banners: [Banner]) {
        self.banners = banners
    }
}

// MARK: - FSPagerViewDataSource

extension BannerCollectionViewCell: FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return banners.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let imageURL = banners[index].url
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.sd_setImage(with: imageURL?.url, completed: nil)
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        return cell
    }
}

// MARK: - FSPagerViewDelegate

extension BannerCollectionViewCell: FSPagerViewDelegate {
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
