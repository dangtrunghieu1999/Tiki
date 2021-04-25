//
//  HeaderedCAPSPageMenuViewController.swift
//  HeaderedTabScrollView
//
//  Created by Stéphane Sercu on 2/10/17.
//

import UIKit

/**
 Basically an PagingMenu with an header on top of it with some cool scrolling effects.
 */
open class HeaderedCAPSPageMenuViewController: AbstractHeaderedTabScrollViewController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // PageMenu
        self.view.addSubview(pageMenuContainer)
        pageMenuContainer.frame = CGRect(x: 0,
                                         y: headerHeight + navBarOffset(),
                                         width: view.frame.width,
                                         height: view.frame.height - navBarOffset())
        pageMenuContainer.translatesAutoresizingMaskIntoConstraints = false
        pageMenuContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        pageMenuContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        tabTopConstraint = pageMenuContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: headerHeight
            + navBarOffset())
        tabTopConstraint!.isActive = true
        pageMenuContainer.heightAnchor.constraint(equalToConstant: view.frame.height - navBarOffset()).isActive = true
        
    }
    public func addPageMenu(menu: CAPSPageMenu) {
        pageMenuController = menu
        pageMenuContainer.addSubview(pageMenuController!.view)
    }
    
    public var pageMenuController: CAPSPageMenu?
    public let pageMenuContainer = UIView()
    
    var otherView: UIView = UIView() {
        didSet {
            pageMenuController?.otherViewContainer = otherView
        }
    }
    
    var otherViewHeight: CGFloat = 50 {
        didSet {
            pageMenuController?.otherViewHeight = otherViewHeight
        }
    }
    
}
