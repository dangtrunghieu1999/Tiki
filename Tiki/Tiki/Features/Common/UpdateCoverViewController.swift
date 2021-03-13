//
//  UpdateProfileBackgroundViewController.swift
//  ZoZoApp
//
//  Created by MACOS on 6/9/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

protocol UpdateCoverImageViewControllerDelegate: class {
    func didSelectSaveButton(image: UIImage?)
}

class UpdateCoverViewController: BaseViewController {
    
    // MARK: - Variables
    
    weak var delegate: UpdateCoverImageViewControllerDelegate?
    
    // MARK: - UI Elements
    
    private lazy var coverImageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        return scrollView
    }()
    
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.defaultAvatar
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 75
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        return imageView
    }()
    
    private let displayNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.titleText
        label.font = UIFont.systemFont(ofSize: FontSize.headline.rawValue)
        return label
    }()
    
    private let darkView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    private let tipLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.moveToEditImage.localized()
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.45)
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        return label
    }()
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBar()
        layoutBackgroundImageScrollView()
        layoutBackgroundImageView()
        layoutAvatarImageView()
        layoutShopNameLabel()
        layoutDarkView()
        layoutTipLabel()
    }
    
    // MARK: - Public methods
    
    func setImageToScrop(image: UIImage) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
            let scaleHeight = ScreenSize.SCREEN_WIDTH / image.size.width
            let scaleWidth = ScreenSize.SCREEN_WIDTH * AppConfig.coverImageRatio / image.size.height
            
            self.coverImageView.image = image
            self.coverImageView.snp.updateConstraints { (make) in
                make.height.equalTo(image.size.height)
                make.width.equalTo(image.size.width)
            }
            
            self.coverImageScrollView.minimumZoomScale = max(scaleWidth, scaleHeight)
            self.coverImageScrollView.zoomScale = max(scaleWidth, scaleHeight)
        }
    }
    
    func setProfileInfo(avatarURL: String?, displayName: String) {
        if let urlString = avatarURL {
            avatarImageView.sd_setImage(with: urlString.url,
                                        placeholderImage: ImageManager.defaultAvatar,
                                        options: .continueInBackground,
                                        completed: nil)
        }
        
        displayNameLabel.text = displayName
    }
    
    // MARK: - UIActions
    
    @objc func tapOnSaveBarButtonItem() {
        guard let image = cropImage() else {
            return
        }
        setImageToScrop(image: image)
        showLoading()
        delegate?.didSelectSaveButton(image: image)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private method
    
    private func cropImage() -> UIImage? {
        guard let image = coverImageView.image else { return nil }
        let scale: CGFloat = 1 / coverImageScrollView.zoomScale
        let x: CGFloat = coverImageScrollView.contentOffset.x * scale
        let y: CGFloat = coverImageScrollView.contentOffset.y * scale
        let width: CGFloat = coverImageScrollView.frame.size.width * scale
        let height: CGFloat = coverImageScrollView.frame.size.height * scale
        guard let cgImage = image.cgImage else { return nil }
        let croptRect = CGRect(x: x, y: y, width: width, height: height)
        guard let croppedCGImage = cgImage.cropping(to: croptRect) else {
            return nil
        }
        
        return UIImage(cgImage: croppedCGImage)
    }
    
    // MARK: - Layouts
    
    private func configNavigationBar() {
        navigationItem.title = TextManager.preview.localized()
        
        let target: Target = (target: self, selector: #selector(tapOnSaveBarButtonItem))
        let saveBarButtonItem = BarButtonItemModel(nil, TextManager.save.localized(), target)
        addBarItems(with: [saveBarButtonItem], type: .right)
    }
    
    private func layoutBackgroundImageScrollView() {
        view.addSubview(coverImageScrollView)
        coverImageScrollView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(ScreenSize.SCREEN_WIDTH * AppConfig.coverImageRatio)
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
            }
        }
    }
    
    private func layoutBackgroundImageView() {
        coverImageScrollView.addSubview(coverImageView)
        coverImageView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(ScreenSize.SCREEN_WIDTH)
            make.height.equalTo(ScreenSize.SCREEN_WIDTH * AppConfig.coverImageRatio)
            make.bottom.equalToSuperview()
        }
    }
    
    private func layoutAvatarImageView() {
        view.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(150)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(coverImageScrollView.snp.bottom)
        }
    }
    
    private func layoutShopNameLabel() {
        view.addSubview(displayNameLabel)
        displayNameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(avatarImageView.snp.bottom).offset(Dimension.shared.largeMargin)
        }
    }
    
    private func layoutDarkView() {
        view.addSubview(darkView)
        darkView.snp.makeConstraints { (make) in
            make.width.bottom.left.equalToSuperview()
            make.top.equalTo(displayNameLabel.snp.bottom).offset(Dimension.shared.largeMargin_90)
        }
    }
    
    private func layoutTipLabel() {
        let estimateWidth = tipLabel.text?.width(withConstrainedHeight: 18, font: tipLabel.font) ?? 210
        view.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.width.equalTo(estimateWidth + 10)
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
            make.top.equalTo(coverImageScrollView).offset(16)
        }
    }
    
}

// MARK: - UIScrollViewDelegate

extension UpdateCoverViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return coverImageView
    }
}
