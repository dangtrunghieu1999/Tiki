//
//  CategoriesTableViewCell.swift
//  Tiki
//
//  Created by Bee_MacPro on 08/06/2021.
//

import UIKit

class CategoriesTableViewCell: BaseTableViewCell {

    fileprivate lazy var containerView: BaseView = {
        let view = BaseView()
        view.backgroundColor = .lightBlue
        view.roundCorners(cornerRadius: 5.0,
                          position: [.topRight, .bottomRight])
        return view
    }()
    
    fileprivate lazy var produtcImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    fileprivate lazy var productTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h3.rawValue)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    let lineView: BaseView = {
        let view = BaseView()
        view.backgroundColor = UIColor.primary
        return view
    }()
    
    fileprivate lazy var triangleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = ImageManager.icon_triangle
        return imageView
    }()
    
    override func initialize() {
        super.initialize()
        layoutContainerView()
        layoutProductTitleLabel()
        layoutProdutcImageView()
        layoutLineView()
        layoutTriangleImageView()
    }
    
    func configCell(image: String?, title: String?) {
        guard let immage = image,
              let title = title else {
            return
        }
        self.produtcImageView.loadImage(by: immage)
        self.productTitleLabel.text = title
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                lineView.isHidden             = false
                triangleImageView.isHidden    = false
                containerView.backgroundColor = .white
            } else {
                lineView.isHidden             = true
                triangleImageView.isHidden    = true
                containerView.backgroundColor = .lightBlue
            }
        }
    }
    
    private func layoutContainerView() {
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.bottom
                .equalToSuperview()
                .offset(-1)
            make.top
                .left
                .right
                .equalToSuperview()
        }
    }
    
    private func layoutProductTitleLabel() {
        containerView.addSubview(productTitleLabel)
        productTitleLabel.snp.makeConstraints { (make) in
            make.left.right
                .equalToSuperview()
                .inset(dimension.smallMargin)
            make.bottom
                .equalToSuperview()
                .inset(dimension.mediumMargin)
        }
    }
    
    private func layoutProdutcImageView() {
        containerView.addSubview(produtcImageView)
        produtcImageView.snp.makeConstraints { (make) in
            make.bottom
                .equalTo(productTitleLabel.snp.top)
                .offset(-dimension.mediumMargin)
            make.centerX
                .equalToSuperview()
            make.width
                .height
                .equalTo(50)
        }
    }
    
    private func layoutLineView() {
        containerView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left
                .equalToSuperview()
            make.top
                .bottom
                .equalToSuperview()
            make.height
                .equalToSuperview()
            make.width
                .equalTo(4)
        }
    }
    
    private func layoutTriangleImageView() {
        addSubview(triangleImageView)
        triangleImageView.snp.makeConstraints { (make) in
            make.right
                .equalToSuperview()
                .offset(2)
            make.width
                .height
                .equalTo(20)
            make.centerY
                .equalToSuperview()
        }
    }
}
