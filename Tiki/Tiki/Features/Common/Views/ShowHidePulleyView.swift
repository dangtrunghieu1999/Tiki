//
//  ShowHidePulleyView.swift
//  Tiki
//
//  Created by Bee_MacPro on 18/05/2021.
//

import UIKit

class ShowHidePulleyView: ThroughView {
    
    // MARK: - Define Components
    lazy var backgroundView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.secondary1.withAlphaComponent(0.8)
        view.isHidden = true
        view.alpha = 0.0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ShowHidePulleyView.touchOnBackgroundView(_:)))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    lazy var pulleyView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.white
        view.addShadow()
        view.layer.cornerRadius = 10.0
        view.alpha = 0.0
        
        if #available(iOS 11.0, *) {
            view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(ShowHidePulleyView.dragPullView(_:)))
        view.addGestureRecognizer(panGesture)
        
        return view
    }()
    
    let ledgeView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.lightSeparator
        view.set(cornerRadius: 4.0)
        return view
    }()
    
    let contentView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    // MARK: - Define Variables
    var minPulleyViewHeight: CGFloat {
        return self.estimatePulleyMinHeight()
    }
    
    var currentPulleyViewHeight: CGFloat = 150
    var animationDuration: TimeInterval = 0.4
    
    var isShow: Bool = false
    
    // MARK: - Override Methods
    override func initialize() {
        super.initialize()
        self.isHidden = true
        self.setupBackgroundView()
        self.setupPulleyView()
        self.setupLedgeView()
        self.setupContentView()
    }
    
    // MARK: - Support Methods
    // Need to overried at child viewcontroller
    func estimatePulleyMinHeight() -> CGFloat {
        return 150
    }
    
    @objc func dragPullView(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: self.pulleyView)
        panGesture.setTranslation(.zero, in: self.pulleyView)
        
        switch panGesture.state {
        case .began:
            self.endEditing(true)
        case .changed:
            if translation.y < 0 && self.currentPulleyViewHeight >= self.minPulleyViewHeight { return }
            self.currentPulleyViewHeight -= translation.y
            self.pulleyViewReSizeAnimation(withDuration: 0.0)
        case .ended:
            if self.currentPulleyViewHeight <= self.minPulleyViewHeight * 3 / 4.0 {
                self.hidePulley()
            } else {
                self.showPulley()
            }
        default:
            break
        }
    }
    
    @objc func touchOnBackgroundView(_ tapGesture: UITapGestureRecognizer) {
        if tapGesture.state == .ended {
            self.hidePulley()
        }
    }
    
    func showPulley() {
        self.isShow = true
        self.isHidden = false
        self.backgroundView.isHidden = false
        self.currentPulleyViewHeight = self.estimatePulleyMinHeight()
        self.remakeShowCurrentPulleyView()
        
        UIView.animate(withDuration: self.animationDuration) {
            self.pulleyView.alpha = 1.0
            self.backgroundView.alpha = 1.0
            self.layoutIfNeeded()
        }
    }
    
    func hidePulley(completion: (() -> Void)? = nil) {
        self.isShow = false
        self.remakeHidePulleyView()
        
        UIView.animate(withDuration: self.animationDuration, animations: {
            self.pulleyView.alpha = 0.01
            self.backgroundView.alpha = 0.0
            self.layoutIfNeeded()
        }) { (bool) in
            if bool {
                self.backgroundView.isHidden = true
                self.isHidden = true
                completion?()
            }
        }
    }
    
    internal func pulleyViewReSizeAnimation(withDuration: TimeInterval) {
        if self.currentPulleyViewHeight < self.minPulleyViewHeight {
            self.remakeShowPulleyViewLessThanMinHeight()
        } else {
            self.remakeShowCurrentPulleyView()
        }
        
        UIView.animate(withDuration: withDuration) {
            self.layoutIfNeeded()
        }
    }
}

// MARK: - Setup Components
extension ShowHidePulleyView {
    
    private func setupBackgroundView() {
        self.addSubview(self.backgroundView)
        self.backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupPulleyView() {
        self.addSubview(self.pulleyView)
        self.pulleyView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(self.minPulleyViewHeight)
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(self.minPulleyViewHeight)
        }
    }
    
    internal func remakeShowCurrentPulleyView() {
        self.pulleyView.snp.remakeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(self.currentPulleyViewHeight)
        }
    }
    
    internal func remakeShowPulleyViewLessThanMinHeight() {
        self.pulleyView.snp.remakeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(self.minPulleyViewHeight - self.currentPulleyViewHeight)
            make.height.equalTo(self.minPulleyViewHeight)
        }
    }
    
    internal func remakeHidePulleyView() {
        self.pulleyView.snp.remakeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(self.minPulleyViewHeight)
            make.height.equalTo(self.minPulleyViewHeight)
        }
    }
    
    private func setupLedgeView() {
        self.pulleyView.addSubview(self.ledgeView)
        self.ledgeView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(dimension.mediumMargin)
            make.width.equalTo(dimension.largeMargin_42)
            make.centerX.equalToSuperview()
            make.height.equalTo(dimension.smallMargin)
        }
    }
    
    private func setupContentView() {
        self.pulleyView.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.top.equalTo(self.ledgeView.snp.bottom).offset(dimension.normalMargin)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-dimension.normalMargin)
        }
    }
}
