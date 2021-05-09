//
//  TagFriendViewController.swift
//  ZoZoApp
//
//  Created by LAP12852 on 9/30/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

protocol TagFriendViewControllerDelegate: class {
    func didSelectTagFriends(_ users: [User])
}

class TagFriendViewController: BaseViewController {
    
    // MARK: - Variables
    
    weak var delegate: TagFriendViewControllerDelegate?
    fileprivate var selectedUsers: [User] = []
    
    // MARK: - UI Elements
    
    fileprivate let searchBottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    private lazy var selectedFriendsView: SelectedFriendsView = {
        let view = SelectedFriendsView()
        view.backgroundColor = UIColor.white
        view.delegate = self
        return view
    }()
    
    fileprivate let selectedFriendsLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.makeShadow()
        return view
    }()
    
    fileprivate lazy var searchResultView: SearchResultView = {
        let view = SearchResultView()
        view.isShowCheckBox = true
        view.delegate = self
        return view
    }()
    
    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TextManager.tagYourFiend.localized()
        setupSearchBar()
        layoutSearchBottomLineView()
        layoutSelectedFriendView()
        layoutSelectedFriendLineView()
        layoutSearchResultView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    // MARK: - Overidde methods
    
    override func searchBarValueChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        searchResultView.searchUser(text: text)
    }
    
    // MARK: - Layout
    
    private func setupSearchBar() {
        searchBar.leftImage = ImageManager.searchGray
        searchBar.placeholder = TextManager.yourFiendWithYou.localized()
        searchBar.layer.borderColor = UIColor.clear.cgColor
        searchBar.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
            make.height.equalTo(36)
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Dimension.shared.normalMargin)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom).offset(Dimension.shared.normalMargin)
            }
        }
    }
    
    private func layoutSearchBottomLineView() {
        view.addSubview(searchBottomLineView)
        searchBottomLineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(searchBar)
            make.height.equalTo(1)
            make.top.equalTo(searchBar.snp.bottom)
        }
    }
    
    private func layoutSelectedFriendView() {
        view.addSubview(selectedFriendsView)
        selectedFriendsView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0)
            if #available(iOS 11, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }
    
    private func layoutSelectedFriendLineView() {
        view.addSubview(selectedFriendsLineView)
        selectedFriendsLineView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalTo(selectedFriendsView)
            make.height.equalTo(1.0)
        }
    }
    
    private func layoutSearchResultView() {
        view.addSubview(searchResultView)
        searchResultView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBottomLineView.snp.bottom).offset(dimension.mediumMargin)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(selectedFriendsView.snp.top).offset(-dimension.mediumMargin)
        }
    }

}

// MARK: - SelectedFriendsViewDelgate

extension TagFriendViewController: SelectedFriendsViewDelgate {
    func didSelectNextButton() {
        delegate?.didSelectTagFriends(selectedFriendsView.users)
        navigationController?.popViewController(animated: true)
    }
    
    func didSelectUser(_ user: User) {
        didSelectSearchResult(user: user)
    }
    
    func didSelectDeleteUser(_ user: User) {
        didSelectSearchResult(user: user)
    }
}

// MARK: - SearchResultViewDelegate

extension TagFriendViewController: SearchResultViewDelegate {
    func didSelectSearchResult(user: User) {
        selectedFriendsView.didSelectUser(user)
        
        if selectedFriendsView.users.isEmpty {
            selectedFriendsView.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
        } else {
            selectedFriendsView.snp.updateConstraints { (make) in
                make.height.equalTo(70)
            }
        }
        
        searchResultView.selectedUsers = selectedFriendsView.users
        view.layoutIfNeeded()
    }
}
