//
//  UIButton+Extension.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/19/21.
//

import UIKit

extension UIButton {
    func addRightIcon(image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(imageView)

        let length = CGFloat(8)
        titleEdgeInsets.right += length

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.titleLabel!.trailingAnchor, constant: 10),
            imageView.centerYAnchor.constraint(equalTo: self.titleLabel!.centerYAnchor, constant: 0),
            imageView.widthAnchor.constraint(equalToConstant: length - 2),
            imageView.heightAnchor.constraint(equalToConstant: length - 2)
        ])
    }
}
