//
//  AdvanedShopCollectionViewCell.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/15/21.
//

import UIKit

class ProductAdvanedShopCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Variables
    
    let withItem = ScreenSize.SCREEN_WIDTH / 3
    
    // MARK: - UI Elements
    
    fileprivate lazy var commitmentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.compensation
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    fileprivate lazy var commitmentLabel: UILabel = {
        let label = UILabel()
        var firstText        = "Hoàn tiền \n"
        var secondText       = "111% \n"
        var thirdText        = "nếu hàng giả"
        
        var attrs1 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: FontSize.h2.rawValue)]
        var attributedString = NSMutableAttributedString(string:firstText, attributes:attrs1)
        
        var attrs2 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: FontSize.h2.rawValue, weight: .bold)]
        var secondBoldText = NSMutableAttributedString(string: secondText, attributes:attrs2)
        attributedString.append(secondBoldText)
        
        var attrs3 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: FontSize.h2.rawValue)]
        var thirdAttributed  = NSMutableAttributedString(string: thirdText, attributes: attrs3)
        
        attributedString.append(thirdAttributed)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.minimumLineHeight = 5
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value:paragraphStyle,
                                      range:NSMakeRange(0, attributedString.length))
        label.attributedText = attributedString
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    fileprivate lazy var guaranteeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.guarantee
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var guaranteeLabel: UILabel = {
        let label = UILabel()
        var firstText        = "Thông tin \n bảo hành \n"
        var secondText       = "XEM CHI TIẾT"
        
        var attrs1 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: FontSize.h2.rawValue)]
        var attributedString = NSMutableAttributedString(string:firstText, attributes:attrs1)
        
        var attrs2 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: FontSize.h2.rawValue, weight: .bold),
                      NSAttributedString.Key.foregroundColor: UIColor.primary]
        var secondBoldText = NSMutableAttributedString(string: secondText, attributes:attrs2)
        attributedString.append(secondBoldText)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.minimumLineHeight = 5
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value:paragraphStyle,
                                      range:NSMakeRange(0, attributedString.length))
        label.attributedText = attributedString
        label.numberOfLines = 3
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapSeeMoreInfo)))
        return label
    }()
    
    fileprivate lazy var refundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.refund
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    fileprivate lazy var refundLabel: UILabel = {
        let label = UILabel()
        var firstText        = "Đổi trả trong \n"
        var secondText       = "30 ngày \n"
        var thirdText        = "nếu sp lỗi"
        
        var attrs1 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: FontSize.h2.rawValue)]
        var attributedString = NSMutableAttributedString(string:firstText, attributes:attrs1)
        
        var attrs2 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: FontSize.h2.rawValue, weight: .bold)]
        var secondBoldText = NSMutableAttributedString(string: secondText, attributes:attrs2)
        attributedString.append(secondBoldText)
        
        var attrs3 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: FontSize.h2.rawValue)]
        var thirdAttributed  = NSMutableAttributedString(string: thirdText, attributes: attrs3)
        
        attributedString.append(thirdAttributed)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.minimumLineHeight = 5
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value:paragraphStyle,
                                      range:NSMakeRange(0, attributedString.length))
        label.attributedText = attributedString
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        layoutCommitmentImageView()
        layoutCommitmentLabel()
        layoutGuaranteeImageView()
        layoutRefundImageView()
        layoutGuaranteeLabel()
        layoutRefundLabel()
    }
    
    // MARK: - UI Action
    
    @objc func tapSeeMoreInfo() {
        print("aa")
    }
    
    // MARK: - Helper Method
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutCommitmentImageView() {
        addSubview(commitmentImageView)
        commitmentImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.left.equalToSuperview().offset(withItem / 2)
            make.width.height.equalTo(35)
        }
    }
    
    private func layoutCommitmentLabel() {
        addSubview(commitmentLabel)
        commitmentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(commitmentImageView.snp.bottom).offset(Dimension.shared.normalMargin)
            make.width.equalTo(withItem)
            make.centerX.equalTo(commitmentImageView)
        }
    }
    
    private func layoutGuaranteeImageView() {
        addSubview(guaranteeImageView)
        guaranteeImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(35)
        }
    }
    
    private func layoutGuaranteeLabel() {
        addSubview(guaranteeLabel)
        guaranteeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(guaranteeImageView.snp.bottom).offset(Dimension.shared.normalMargin)
            make.width.equalTo(withItem)
            make.centerX.equalToSuperview()
        }
    }
    
    private func layoutRefundImageView() {
        addSubview(refundImageView)
        refundImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview().offset(-withItem / 2)
            make.width.height.equalTo(35)
        }
    }
    
    private func layoutRefundLabel() {
        addSubview(refundLabel)
        refundLabel.snp.makeConstraints { (make) in
            make.top.equalTo(refundImageView.snp.bottom).offset(Dimension.shared.normalMargin)
            make.width.equalTo(withItem)
            make.centerX.equalTo(refundImageView)
        }
    }
    
}
