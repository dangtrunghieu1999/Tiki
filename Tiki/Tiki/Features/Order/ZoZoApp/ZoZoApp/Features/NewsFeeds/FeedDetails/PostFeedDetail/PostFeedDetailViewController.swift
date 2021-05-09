//
//  PostFeedDetailViewController.swift
//  ZoZoApp
//
//  Created by LAP12852 on 9/19/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import IGListKit
import IQKeyboardManagerSwift
import Photos

class PostFeedDetailViewController: BaseViewController {
    
    enum PostFeedType: Int {
        case none       = 0
        case photo      = 1
        case tagFriend  = 2
        case emoji      = 3
        case checkIn    = 4
    }

    // MARK: - Variables
    
    private lazy var adapter: ListAdapter = {
        let updater = ListAdapterUpdater()
        let adapter = ListAdapter(updater: updater, viewController: self, workingRangeSize: 5)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        return adapter
    }()
    
    fileprivate var dataSource: [BaseFeedSectionModel] = []
    fileprivate var model = PostFeedDetailSectionModel()
    fileprivate var selectedAssets: [PHAsset] = []
    fileprivate var isViewDisappear           = false
    
    // MARK: - UI Elements
    
    private lazy var postFeedActionView: PostFeedActionView = {
        let view = PostFeedActionView()
        view.delegate = self
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
    
    // MARK: - LifeCycles
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        isViewDisappear = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGestureOnSuperView.cancelsTouchesInView = true
        navigationItem.title = TextManager.postFeed.localized()
        setRightNavigationBar(ImageManager.postFeedDisable)
        
        dataSource.append(model)
        adapter.reloadData(completion: nil)
        registerKeyboardNotification()
        
        layoutCollectionView()
        layoutPostFeedActionView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        isViewDisappear = true
    }
    
    // MARK: - Public methods
    
    func configData(postFeedType: PostFeedType) {
        switch postFeedType {
        case .none:
            break
        case .photo:
            didSelectPostPhotoButton()
            break
        case .tagFriend:
            didSelectTagFriendButton()
            break
        case .emoji:
            didSelectEmojiButton()
            break
        case .checkIn:
            didSelectLocationButton()
            break
        }
    }
    
    // MARK: - Override methods
    
    override func touchUpInRightBarButtonItem() {
        
    }
    
    // MARK: - UI Actions
    
    override func keyboardWillShow(_ notification: NSNotification) {
        guard !isViewDisappear else { return }
        
        let keyboardAnimationInfo = notification.keyboardAnimationInfo
        let keyboardHeight = keyboardAnimationInfo.constraint
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight + 80, right: 0)
        postFeedActionView.snp.updateConstraints { (make) in
            if #available(iOS 11, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-keyboardHeight)
            } else {
                make.bottom.equalToSuperview().offset(-keyboardHeight)
            }
        }
        
        UIView.animateKeyframes(withDuration: keyboardAnimationInfo.duration,
                                delay: 0.0,
                                options: keyboardAnimationInfo.option,
                                animations: {
                                    self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    override func keyboardWillHide(_ notification: NSNotification) {
        guard !isViewDisappear else { return }
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let keyboardAnimationInfo = notification.keyboardAnimationInfo
        
        postFeedActionView.snp.updateConstraints { (make) in
            if #available(iOS 11, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
        
        UIView.animateKeyframes(withDuration: keyboardAnimationInfo.duration,
                                delay: 0.0,
                                options: keyboardAnimationInfo.option,
                                animations: {
                                    self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // MARK: - Layout
    
    private func layoutCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.width.top.centerX.equalToSuperview()
            if #available(iOS 11, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-80)
            } else {
                make.bottom.equalToSuperview().offset(-80)
            }
        }
    }
    
    private func layoutPostFeedActionView() {
        view.addSubview(postFeedActionView)
        postFeedActionView.snp.makeConstraints { (make) in
            make.width.centerX.equalToSuperview()
            make.height.equalTo(70)
            if #available(iOS 11, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }
    
}

// MARK: - ListAdapterDataSource

extension PostFeedDetailViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return dataSource
    }
    
    func listAdapter(_ listAdapter: ListAdapter,
                     sectionControllerFor object: Any) -> ListSectionController {
        return PostFeedDetailSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

// MARK: - PostFeedActionViewDelegate

extension PostFeedDetailViewController: PostFeedActionViewDelegate {
    func didSelectLocationButton() {
        let viewController = CheckInViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func didSelectTagFriendButton() {
        let viewController = TagFriendViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func didSelectEmojiButton() {
        let viewController = FeedEmojiViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func didSelectPostPhotoButton() {
        AppRouter.presentToImagePicker(pickerDelegate: self, limitImage: 100, selecedAssets: selectedAssets)
    }
}

// MARK: - ImagePickerControllerDelegate

extension PostFeedDetailViewController: ImagePickerControllerDelegate {
    func imagePickerController(_ picker: ImagePickerController,
                               shouldLaunchCameraWithAuthorization status: AVAuthorizationStatus) -> Bool {
        return true
    }
    
    func imagePickerController(_ picker: ImagePickerController, didFinishPickingImageAssets assets: [PHAsset]) {
        dismiss(animated: true, completion: nil)
        selectedAssets = assets
        
        var images: [UIImage] = Array(repeating: UIImage(), count: assets.count)
        let dispatchGroup = DispatchGroup()
        
        DispatchQueue.global(qos: .userInteractive).async {
            for (index, asset) in assets.enumerated() {
                dispatchGroup.enter()
                asset.getUIImage(completion: { (image) in
                    if let image = image, index < images.count {
                        images[index] = image
                    }
                    dispatchGroup.leave()
                })
            }
            
            let result = dispatchGroup.wait(timeout: .now() + .seconds(5));
            if result == .success {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.model.setFeedImages(images)
                    self.adapter.reloadData(completion: nil)
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: ImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
