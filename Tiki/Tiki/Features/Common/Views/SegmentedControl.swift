//
//  SegmentedControl.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 5/16/21.
//

import UIKit

class SegmentedControl: UIControl {

    private var buttons = [UIButton]()
    
    private var titles: [String]
    
    private(set) var selectedSegmentIndex = 0
    private var textColor: UIColor
    private var selectedTextColor: UIColor
    private var font: UIFont
    private var selectedFont: UIFont
    private var selector = UIView()
    
    private var animtedLeadingAnchor: NSLayoutConstraint?
    
    init(titles: [String], textColor: UIColor, selectedTextColor: UIColor, font: UIFont, selectedFont: UIFont) {
        self.textColor = textColor
        self.selectedTextColor = selectedTextColor
        self.font = font
        self.selectedFont = selectedFont
        self.titles = titles
        super.init(frame: .zero)
        updateView()
    }
    
    required init?(coder: NSCoder) {
        self.textColor = .lightGray
        self.selectedTextColor = .green
        self.font = UIFont()
        self.selectedFont = UIFont()
        self.titles = []
        super.init(coder: coder)
        updateView()
    }
    
    private func updateView() {
        buttons.removeAll()
        subviews.forEach {
            $0.removeFromSuperview()
        }
        guard titles.count > 0 else { return }
        for title in titles {
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.titleLabel?.font = font
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            buttons.append(button)
        }
        
        buttons[selectedSegmentIndex].setTitleColor(selectedTextColor, for: .normal)
        buttons[selectedSegmentIndex].titleLabel?.font = selectedFont
        
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        setupSelector()
    }
    
    private func setupSelector() {
        selector.backgroundColor = selectedTextColor
        addSubview(selector)
        selector.translatesAutoresizingMaskIntoConstraints = false
        selector.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        animtedLeadingAnchor = selector.leadingAnchor.constraint(equalTo: leadingAnchor)
        animtedLeadingAnchor?.isActive = true
        selector.heightAnchor.constraint(equalToConstant: 2).isActive = true
        let ratio = 1 / CGFloat(titles.count)
        selector.widthAnchor.constraint(equalTo: widthAnchor, multiplier: ratio).isActive = true
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        for (index, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            btn.titleLabel?.font = font
            if btn == sender {
                selectedSegmentIndex = index
                let constant = frame.width / CGFloat(buttons.count) * CGFloat(index)
                animtedLeadingAnchor?.constant = constant
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.layoutIfNeeded()
                }
                btn.setTitleColor(selectedTextColor, for: .normal)
                btn.titleLabel?.font = selectedFont
            }
        }
        sendActions(for: .valueChanged)
    }
    
    func set(titles: [String]) {
        self.titles = titles
        updateView()
    }

}
