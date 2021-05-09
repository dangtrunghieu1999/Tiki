//
//  SelectedFriendsView.swift
//  ZoZoApp
//
//  Created by LAP12852 on 10/20/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

protocol SelectedFriendsViewDelgate: class {
    func didSelectNextButton()
    func didSelectUser(_ user: User)
    func didSelectDeleteUser(_ user: User)
}

class SelectedFriendsView: BaseView {

    // MARK: - Variables
    
    weak var delegate: SelectedFriendsViewDelgate?
    
    private (set) var users: [User] = []
    
    // MARK: - UI Elements
    
    fileprivate lazy var friendsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerReusableCell(SelectedFriendCollectionViewCell.self)
        return collectionView
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.next, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(touchInNextButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycles
  
    override func initialize() {
        layoutNextButton()
        layoutFriendCollectionView()
    }
    
    // MARK: - Public method
    
    func didSelectUser(_ user: User) {
        if let index = users.firstIndex(of: user) {
            users.remove(at: index)
        } else {
            users.append(user)
        }
        friendsCollectionView.reloadData()
    }
    
    // MARK: - UI Actions
    
    @objc private func touchInNextButton() {
        delegate?.didSelectNextButton()
    }
 
    // MARK: - Layout
    
    private func layoutNextButton() {
        addSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(dimension.normalMargin)
            make.width.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
    }

    private func layoutFriendCollectionView() {
        addSubview(friendsCollectionView)
        friendsCollectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(4)
            make.leading.equalToSuperview()
            make.trailing.equalTo(nextButton.snp.leading).inset(dimension.normalMargin)
            make.height.equalTo(70)
        }
    }
    
}

// MARK: - UICollectionViewDelegate

extension SelectedFriendsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let user = users[safe: indexPath.row] {
            didSelectUser(user)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension SelectedFriendsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SelectedFriendCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.delegate = self
        if let user = users[safe: indexPath.row] {
            cell.configure(user.pictureURL, indexPath: indexPath)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SelectedFriendsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 70)
    }
}

// MARK: - SelectedFriendCollectionViewCellDelegate

extension SelectedFriendsView: SelectedFriendCollectionViewCellDelegate {
    func didSelectDelete(at indexPath: IndexPath) {
        if let user = users[safe: indexPath.row] {
            delegate?.didSelectDeleteUser(user)
        }
    }
}
