//
//  PaymentViewController.swift
//  Tiki
//
//  Created by Bee_MacPro on 06/06/2021.
//

import UIKit


enum PaymentSection: Int {
    case method       = 0
    case section1     = 1
    case bill         = 2

    static func numberOfSections() -> Int {
        return 3
    }
}

class PaymentViewController: BaseViewController {

    // MARK: - UI Elements
    
    private let bottomView: BaseView = {
        let view = BaseView()
        view.addTopBorder(with: UIColor.separator, andWidth: 1)
        view.layer.masksToBounds = true
        return view
    }()
    
    fileprivate lazy var intoMoneyTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = TextManager.totalMoney
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        return label
    }()
    
    fileprivate lazy var totalMoneyTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = CartManager.shared.totalMoney.currencyFormat
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue)
        label.textColor = UIColor.primary
        return label
    }()
    
    private lazy var buyButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.next, for: .normal)
        button.backgroundColor = UIColor.primary
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        return button
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.separator
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.registerReusableCell(MethodCollectionViewCell.self)
        collectionView.registerReusableCell(FooterCollectionViewCell.self)
        collectionView.registerReusableCell(BillerCollectionViewCell.self)
        return collectionView
    }()
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = TextManager.paymentForm
        layoutBottomView()
        layoutBuyButton()
        layoutIntoMoneyTitleLabel()
        layoutTotalMoneyTitleLabel()
        layoutCollectionView()
    }
    
    private func layoutBottomView() {
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.bottom
                    .equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom
                    .equalTo(bottomLayoutGuide.snp.top)
            }
            make.left.right.equalToSuperview()
            make.height.equalTo(120)
        }
    }
    
    private func layoutBuyButton() {
        bottomView.addSubview(buyButton)
        buyButton.snp.makeConstraints { (make) in
            make.left.right
                .equalToSuperview()
                .inset(dimension.normalMargin)
            make.height
                .equalTo(dimension.defaultHeightButton)
            make.bottom
                .equalToSuperview()
                .offset(-dimension.mediumMargin)
        }
    }
    
    private func layoutIntoMoneyTitleLabel() {
        bottomView.addSubview(intoMoneyTitleLabel)
        intoMoneyTitleLabel.snp.makeConstraints { (make) in
            make.left
                .equalTo(buyButton)
            make.top
                .equalToSuperview()
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutTotalMoneyTitleLabel() {
        bottomView.addSubview(totalMoneyTitleLabel)
        totalMoneyTitleLabel.snp.makeConstraints { (make) in
            make.bottom
                .equalTo(buyButton.snp.top)
                .offset(-dimension.normalMargin)
            make.right
                .equalTo(buyButton)
        }
    }
    
    private func layoutCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide)
                
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
            }
            make.bottom.equalTo(bottomView.snp.top)
        }
    }
}

extension PaymentViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return PaymentSection.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
       return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = PaymentSection(rawValue: indexPath.section)
        switch type {
        case .method:
            let cell: MethodCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        case .section1:
            let cell: FooterCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        case .bill:
            let cell: BillerCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PaymentViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        let type  = PaymentSection(rawValue: indexPath.section)
        switch type {
        case .section1:
            return CGSize(width: width, height: 8)
        case .method:
            return CGSize(width: width, height: 200)
        case .bill:
            return CGSize(width: width, height: 200)
        default:
            return CGSize(width: width, height: 0)
        }
    }
}
