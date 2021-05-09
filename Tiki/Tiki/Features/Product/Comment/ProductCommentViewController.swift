//
//  ProductCommentViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/20/21.
//

import UIKit
import IQKeyboardManagerSwift

protocol ProductCommentViewControllerDelegate: class {
    func updateNewComments(_ comments: [Comment])
}

class ProductCommentViewController: BaseViewController {
    
    // MARK: - Variables
    
    weak var delegate: ProductCommentViewControllerDelegate?
    
    fileprivate var comments: [Comment] = []
    fileprivate var isFirstApperance: Bool = false
    fileprivate var chatInputPresenter: AnyObject!
    
    fileprivate var replyComment: Comment?
    fileprivate var productId: Int?
    
    // MARK: - UI Elements
    
    private var emptyComment: EmptyView = {
        let view = EmptyView()
        view.image = ImageManager.comment
        view.message = TextManager.emptyComment.localized()
        view.updateImageSize(CGSize(width: 40, height: 40))
        view.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        view.isHidden = true
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        collectionView.registerReusableCell(ProductParentCommentCollectionViewCell.self)
        collectionView.registerReusableCell(ProductChildCommentCollectionViewCell.self)
        collectionView.registerReusableSupplementaryView(
            GrayCollectionViewFooterCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
        collectionView.registerReusableSupplementaryView(
            BaseCollectionViewHeaderFooterCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        return collectionView
    }()
    
    fileprivate lazy var chatInputView: ChatInputView = {
        let view = ChatInputView()
        view.delegate = self
        return view
    }()
    
    private lazy var replyCommentView: ReplyCommentView = {
        let replyCommentView = ReplyCommentView()
        replyCommentView.delegate = self
        return replyCommentView
    }()
    
    // MARK: - LifeCycles
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGestureOnSuperView.cancelsTouchesInView = true
        navigationItem.title = TextManager.comment.localized()
        
        layoutCommentCollectionView()
        layoutEmptyComment()
        layoutChatInputView()
        layoutReplyCommentView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnSuperView))
        view.addGestureRecognizer(tapGesture)
        registerKeyboardNotification()
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
        chatInputView.endEditing(true)
        delegate?.updateNewComments(comments)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if replyComment != nil {
            chatInputView.beginEditing()
        }
    }
    
    // MARK: - Public methods
    
    func configData(comments: [Comment]) {
        self.comments = comments
        emptyComment.isHidden = !comments.isEmpty
        collectionView.reloadData()
    }
    
    func configData(productId: Int?, replyComment: Comment? = nil) {
        self.productId    = productId
        self.replyComment = replyComment
        if let comment = replyComment {
            replyCommentView.replyForComment(comment)
        }
    }
    
    // MARK: - API Request
    
    private func postComment(message: String?) {
        guard let message       = message else { return }
        guard let productId     = productId else { return }
        guard let currentUser   = UserManager.user else { return }
        
        let newComment          = Comment()
        newComment.content      = message
        newComment.productId    = productId
        newComment.userId       = currentUser.id
        newComment.userAvatar   = currentUser.pictureURL
        newComment.fullName     = currentUser.fullName
        newComment.rating       = replyCommentView.ratingValue
        
        if let replyComment = replyComment {
            if let parentId = replyComment.parentId {
                newComment.parentId = parentId
            } else {
                newComment.parentId = replyComment.id
            }
        }
        
        let endPoint = ProductEndPoint.createComment(parameters: newComment.toDictionary())
        
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            guard let self = self else { return }
            
            if let replyComment = self.replyComment {
                AlertManager.shared.showToast(message: TextManager.replyCommentSuccess.localized())
                
                var parentId: Int = replyComment.id ?? 0
                if let id = replyComment.parentId {
                    parentId = id
                }
                
                if let index = self.comments.firstIndex(where: { $0.id == parentId }) {
                    self.comments[index].commentChild.insert(newComment, at: 0)
                }
            } else {
                self.comments.insert(newComment, at: 0)
                AlertManager.shared.showToast(message: TextManager.createCommentSuccess.localized())
            }
            
            self.emptyComment.isHidden = !self.comments.isEmpty
            self.chatInputView.clearInputText()
            self.replyCommentView.ratingValue = 0.0
            self.collectionView.reloadData()
            }, onFailure: { (apiError) in
                AlertManager.shared.showToast()
        }) {
            AlertManager.shared.showToast()
        }
    }
    
    // MARK: - UI Handler
    
    override func keyboardWillShow(_ notification: NSNotification) {
        let keyboardAnimationInfo = notification.keyboardAnimationInfo
        let keyboardHeight = keyboardAnimationInfo.constraint
        
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: keyboardHeight + 10, right: 0)
        chatInputView.snp.updateConstraints { (make) in
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
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        let keyboardAnimationInfo = notification.keyboardAnimationInfo
        
        chatInputView.snp.updateConstraints { (make) in
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
    
    @objc private func tapOnSuperView() {
        chatInputView.endEditing(true)
    }
    
    // MARK: - Helper methods
    
    fileprivate func collectionViewScrollToIndexPath(_ indexPath: IndexPath) {
        collectionView.safeSelectItem(at: indexPath, animated: true, scrollPosition: .top)
    }
    
    override func addTapOnSuperViewDismissKeyboard() {}
    
    // MARK: - Layouts
    
    private func layoutEmptyComment() {
        view.addSubview(emptyComment)
        emptyComment.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.width.height.equalTo(100)
        }
    }
    
    private func layoutCommentCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.width.top.centerX.equalToSuperview()
            if #available(iOS 11, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-120)
            } else {
                make.bottom.equalToSuperview().offset(-120)
            }
        }
    }
    
    private func layoutChatInputView() {
        view.addSubview(chatInputView)
        chatInputView.snp.makeConstraints { (make) in
            make.width.centerX.equalToSuperview()
            if #available(iOS 11, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }
    
    private func layoutReplyCommentView() {
        view.addSubview(replyCommentView)
        replyCommentView.snp.makeConstraints { (make) in
            make.width.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(chatInputView.snp.top)
            make.height.equalTo(60)
        }
    }
    
}

// MARK: - UICollectionViewDelegate

extension ProductCommentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        chatInputView.endEditing(true)
    }
}

// MARK: - UICollectionViewDataSource

extension ProductCommentViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return comments[safe: section]?.allComments.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let comment = comments[indexPath.section].allComments[indexPath.row]
        
        if comment.isParrentComment {
            let cell: ProductParentCommentCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configData(comment: comment)
            cell.delegate = self
            return cell
        } else {
            let cell: ProductChildCommentCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configData(comment: comment)
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header: BaseCollectionViewHeaderFooterCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
            return header
        } else {
            return UICollectionReusableView()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProductCommentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let comment = comments[indexPath.section].allComments[indexPath.row]
        return CGSize(width: collectionView.frame.width,
                      height: ProductParentCommentCollectionViewCell.estimateHeight(comment))
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 12.0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
}

// MARK: - ProductDetailCommentCollectionViewCellDelegate

extension ProductCommentViewController: ProductDetailCommentCollectionViewCellDelegate {
    func didSelectLikeComment(_ comment: Comment) {
        
    }
    
    func didSelectReplyComment(_ comment: Comment) {
        chatInputView.beginEditing()
        configData(productId: productId, replyComment: comment)
    }
}

// MARK: - ChatInputViewDelegate

extension ProductCommentViewController: ChatInputViewDelegate {
    func didSelectSendMessage(view: ChatInputView, message: String?) {
        postComment(message: message)
    }
}

// MARK: - ReplyCommentViewDelegate

extension ProductCommentViewController: ReplyCommentViewDelegate {
    func didSelectClose(_ view: ReplyCommentView) {
        replyComment = nil
        replyCommentView.updateReplyCommentType(.rating)
    }
}
