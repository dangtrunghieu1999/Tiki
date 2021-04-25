//
//  ImageCollectionViewCell.swift
//  Buyer
//
//  Created by MACOS on 11/16/18.
//  Copyright © 2018 Sendo.vn. All rights reserved.
//

import UIKit

class ScrollImageCollectionViewCell: BaseCollectionViewCell {
    @IBOutlet weak var imageScrollView: ImageScrollView?
    private var imageView = UIImageView()
    
    override func initialize() {
        imageScrollView?.setup()
        imageScrollView?.imageContentMode = .aspectFit
        imageScrollView?.initialOffset = .center
    }
    
    func setupData(with urlString: String?) {
        if var urlString = urlString, urlString != "" {
            urlString = urlString.addImageDomainIfNeeded()
            imageView.sd_setImage(with: urlString.url)
            { (image, error, type, url) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.000001, execute: { [weak self] in
                    guard let self = self else { return }
                    if let image = image {
                        self.imageScrollView?.display(image: image)
                    }
                })
            }
        } else {
            setupData(with: ImageManager.imagePlaceHolder)
            AlertManager.shared.showToast(message: TextManager.noPreview.localized())
        }
    }
    
    func setupData(with image: UIImage?) {
        if let image = image {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.000001, execute: { [weak self] in
                guard let self = self else { return }
                self.imageScrollView?.display(image: image)
            })
        }
    }
    
}
