//
//  PostFeedInputStatusModel.swift
//  ZoZoApp
//
//  Created by LAP12852 on 9/21/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class PostFeedInputStatusModel: BaseFeedSectionModel {
    
    private typealias SELF = PostFeedInputStatusModel;
    
    weak var cell: PostFeedInputStatusCollectionViewCell?

    static let statusFont           = UIFont.systemFont(ofSize: FontSize.body.rawValue)
    static let margin: CGFloat      = 10
    
    var textHeight: CGFloat         = 0 {
        didSet {
            previousTextHeight = oldValue
        }
    }
    
    var currentText: String? {
        return cell?.inputTextView.text
    }
    
    private (set) var previousTextHeight: CGFloat?
    
    override func cellSize() -> CGSize {
        var estimateHeight = textHeight + 60
        if estimateHeight < 90 {
            estimateHeight = 90
        }
        return CGSize(width: ScreenSize.SCREEN_WIDTH, height: estimateHeight)
    }
    
    func estimateTextHeight(_ text: String) -> CGFloat {
        let width = ScreenSize.SCREEN_WIDTH - 2 * SELF.margin
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        label.text = text
        label.lineBreakMode = .byWordWrapping
        label.font = SELF.statusFont
        label.sizeToFit()
        let frame = label.textRect(forBounds: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude),
                                   limitedToNumberOfLines: 0)
        return frame.size.height
    }
    
    func needUpdateHeight(_ newTextHeight: CGFloat) -> Bool {
        if newTextHeight != previousTextHeight {
            return true
        } else {
            return false
        }
    }
    
}
