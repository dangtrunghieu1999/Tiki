//
//  ShipAddressTableViewFooter.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 5/6/21.
//

import UIKit

protocol ShipAddressTableViewFooterDelegate: class {
    func didTapView()
}

class ShipAddressTableViewFooter: BaseTableViewHeaderFooter {

    // MARK: - Variables
    
    weak var delegateShip: ShipAddressTableViewFooterDelegate?
    
    // MARK: - UI Elements
    
    fileprivate lazy var topView: BaseView = {
        let view = BaseView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .semibold)
        label.text = TextManager.addAddress
        return label
    }()
    
    fileprivate lazy var nextImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.image = ImageManager.more
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    fileprivate lazy var eventView: BaseView = {
        let view = BaseView()
        view.backgroundColor = UIColor.clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        layoutTopView()
        layoutNextImageView()
        layoutTitleLabel()
        layoutEventView()
    }
    
    // MARK: - Helper Method
    
    @objc private func handleTap() {
        delegateShip?.didTapView()
    }
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutTopView() {
        addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
                .offset(Dimension.shared.mediumMargin)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func layoutEventView() {
        topView.addSubview(eventView)
        eventView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func layoutNextImageView() {
        topView.addSubview(nextImageView)
        nextImageView.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
                .offset(-Dimension.shared.normalMargin)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(12)
        }
    }
    
    private func layoutTitleLabel() {
        topView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
                .offset(Dimension.shared.normalMargin)
            make.right.equalTo(nextImageView.snp.left)
                .offset(-Dimension.shared.normalMargin)
            make.centerY.equalToSuperview()
        }
    }

}
