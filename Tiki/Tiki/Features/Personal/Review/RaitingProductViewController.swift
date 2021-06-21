//
//  RaitingProductViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/22/21.
//

import UIKit

enum RattingSegmmentType {
    case waitReview
    case haveReview
    
    var viewController: BaseViewController {
        switch self {
        case .waitReview:
              return WaitingReviewViewController()
        case .haveReview:
            return AlreadyReviewViewController()
        }
    }
}

class RaitingProductViewController: BaseViewController {

    // MARK: - Define Components
    let topView: BaseView = {
        let view = BaseView(frame: .zero)
        view.backgroundColor = UIColor.separator
        view.addShadow()
        return view
    }()
    
    private lazy var segmentedControl: SegmentedControl = {
        let titles = [TextManager.waitReview, TextManager.haveReview]
        let segment = SegmentedControl(titles: titles, textColor: UIColor.bodyText,
                                       selectedTextColor: UIColor.primary,
                                       font: UIFont.systemFont(ofSize: FontSize.h2.rawValue, weight: .semibold),
                                       selectedFont: UIFont.systemFont(ofSize: FontSize.h2.rawValue, weight: .semibold))
        segment.addTarget(self, action: #selector(sectionDidChange(_:)), for: .valueChanged)
        segment.backgroundColor = .white
        return segment
    }()
    
    lazy var myScrollView: BaseScrollView = {
        let scrollView = BaseScrollView(frame: .zero)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = false
        return scrollView
    }()
    
    let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    // MARK: - Define Variables
    let segmentTypes: [RattingSegmmentType] = [.waitReview, .haveReview]
    
    private var childVCs: [BaseViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = TextManager.ratingForProduct
        self.setupTopView()
        self.setupSegmentedControl()
        self.setupScrollView()
        self.setupContentStackView()
        self.setupChildViewControllers()
    }
}

// MARK: - Setup Components
extension RaitingProductViewController {
    
    private func setupTopView() {
        self.view.addSubview(self.topView)
        self.topView.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
            }
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupSegmentedControl() {
        self.topView.addSubview(self.segmentedControl)
        self.segmentedControl.snp.makeConstraints { (make) in
            make.height.equalTo(dimension.largeMargin_48)
            make.bottom.equalToSuperview()
            make.leading.trailing.top.equalToSuperview()
        }
    }
    
    private func setupScrollView() {
        self.view.insertSubview(self.myScrollView, belowSubview: self.topView)
        self.myScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(self.topView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupContentStackView() {
        self.myScrollView.view.addSubview(self.contentStackView)
        self.contentStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(self.myScrollView)
        }
    }
    
    private func setupChildViewControllers() {
        self.childVCs.removeAll()
        
        for type in self.segmentTypes {
            let viewController = type.viewController
            self.addChild(viewController)
            self.childVCs.append(viewController)
            self.contentStackView.addArrangedSubview(viewController.view)
            
            viewController.view.snp.remakeConstraints { (remake) in
                remake.width.equalTo(self.view)
                remake.height.equalTo(self.myScrollView)
            }
            
            viewController.didMove(toParent: self)
        }
    }
}

// MARK: - Segmented Control Actions
extension RaitingProductViewController {
    
    @objc func sectionDidChange(_ sender: SegmentedControl) {
        
        let index = sender.selectedSegmentIndex
        self.scrollView.setContentOffset(CGPoint(x: CGFloat(index) * dimension.widthScreen , y: 0), animated: true)
        
        guard let segmentType = self.segmentTypes[safe: index] else { return }
        switch segmentType {
        case .waitReview:
            guard (self.childVCs[safe: index] as? WaitingReviewViewController) != nil else { return }
        case .haveReview:
            guard (self.childVCs[safe: index] as? AlreadyReviewViewController) != nil else { return }
        }
    }
}
