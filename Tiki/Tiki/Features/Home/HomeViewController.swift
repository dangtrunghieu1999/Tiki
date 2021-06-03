//
//  HomeViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 2/28/21.
//

import UIKit
import IGListKit
import SwiftyJSON

enum HomeSection: Int {
    case banner     = 0
    case menu       = 1
    case seperator  = 2
    case header     = 3
    case product    = 4
    
    static func numberOfSection() -> Int {
        return 5
    }
}

class HomeViewController: BaseViewController {
    
    // MARK: - Variables
    
    fileprivate var viewModel = HomeViewModel()
    fileprivate var banners: [Banner] = []
    // MARK: - UI Elements
    
    fileprivate lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.background
        refreshControl.addTarget(self, action: #selector(pullToRefresh),
                                 for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing      = 4
        layout.minimumInteritemSpacing = 0
        let collectionView             = UICollectionView(frame: .zero,
                                                          collectionViewLayout: layout)
        collectionView.backgroundColor = .lightBackground
        collectionView.refreshControl  = refreshControl
        collectionView.frame           = view.bounds
        collectionView.dataSource      = self
        collectionView.delegate        = self
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonNavBar()
        registerCell()
        configNavigationBar()
        layoutCollectionView()
    }
    
    // MARK: - Helper Method
    
    private func registerCell() {
        self.collectionView.registerReusableCell(BannerCollectionViewCell.self)
        self.collectionView.registerReusableCell(MenuCollectionViewCell.self)
        self.collectionView.registerReusableCell(FooterCollectionViewCell.self)
        self.collectionView.registerReusableCell(HeaderCollectionViewCell.self)
        self.collectionView.registerReusableCell(ProductCollectionViewCell.self)
    }
    
    private func configNavigationBar() {
        let height = self.tabBarController?.tabBar.frame.height ?? 0
        self.collectionView.contentInset.bottom     = height
        self.tabBarController?.tabBar.isTranslucent = false
    }
    
    private func setButtonNavBar() {
        self.navigationItem.titleView      = searchBar
        navigationItem.rightBarButtonItems = [cartBarButtonItem,
                                              notifiBarButtonItem]
    }
    
    // MARK: = UIAction
    
    override func touchInSearchBar() {
        AppRouter.pushViewToSearchBar(viewController: self)
        searchBar.endEditing(true)
    }
    
    @objc private func pullToRefresh() {
        
    }
    
    // MARK: - Layout
    
    private func layoutCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaInsets)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
            }
            make.left.right.bottom.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = ScreenSize.SCREEN_WIDTH
        let type  = HomeSection(rawValue: indexPath.section)
        switch type {
        case .banner:
            return CGSize(width: width, height: 140)
        case .menu:
            return CGSize(width: width, height: 180)
        case .seperator:
            return CGSize(width: width, height: 8)
        case .header:
            return CGSize(width: width, height: 40)
        case .product:
            return CGSize(width: (width - 4) / 2, height: 320)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return HomeSection.numberOfSection()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        let type = HomeSection(rawValue: section)
        switch type {
        case .banner, .menu, .seperator, .header:
            return 1
        case .product:
            if viewModel.products.isEmpty {
                return 4
            } else {
                return viewModel.products.count
            }
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = HomeSection(rawValue: indexPath.section)
        switch type {
        case .banner:
            let cell: BannerCollectionViewCell  = collectionView.dequeueReusableCell(for: indexPath)
            cell.configCell(banners: banners)
            return cell
        case .menu:
            let cell: MenuCollectionViewCell    = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        case .seperator:
            let cell: FooterCollectionViewCell  = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        case .header:
            let cell: HeaderCollectionViewCell  = collectionView.dequeueReusableCell(for: indexPath)
            cell.configTitle(title: TextManager.recommendProduct)
            return cell
        case .product:
            let cell: ProductCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}
