//
//  BaseUIViewController.swift
//  ZoZoApp
//
//  Created by MACOS on 5/30/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import JGProgressHUD

enum BarButtonItemType {
    case left
    case right
}

typealias Target = (target: Any?, selector: Selector)

struct BarButtonItemModel {
    var image: UIImage?
    var title: String?
    var target: Target
    
    init(_ image: UIImage?, _ target: Target) {
        self.image = image
        self.target = target
    }
    
    init(_ image: UIImage? = nil, _ title: String? = nil, _ target: Target) {
        self.image = image
        self.title = title
        self.target = target
    }
}

// MARK: -

open class BaseViewController: UIViewController {
    
    // MARK: - Variables
    
    var isRequestingAPI = true
    var scrollDelegateFunc: ((UIScrollView) -> Void)?
    
    // MARK: - UI Elements
    
    lazy var searchBar: PaddingTextField = {
        let searchBar = PaddingTextField()
        searchBar.setDefaultBackgroundColor()
        searchBar.layer.cornerRadius = 5
        searchBar.layer.masksToBounds = true
        searchBar.placeholder = TextManager.search.localized()
        searchBar.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        searchBar.returnKeyType = .search
        var rect = navigationController?.navigationBar.frame ?? CGRect.zero
        rect.size.height = 36
        searchBar.frame = rect
        searchBar.clearButtonMode = .whileEditing
        searchBar.addTarget(self, action: #selector(touchInSearchBar), for: .editingDidBegin)
        searchBar.addTarget(self, action: #selector(searchBarValueChange(_:)), for: .editingChanged)
        searchBar.delegate = self
        return searchBar
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchInScrollView))
        tapGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapGesture)
        return scrollView
    }()
    
    private lazy var hub: JGProgressHUD = {
        let hub = JGProgressHUD(style: .dark)
        return hub
    }()
    
    private (set) lazy var cartButton: BadgeButton = {
        let button = BadgeButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.setImage(ImageManager.whiteCart, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.badgeNumber = CartManager.shared.totalProducts
        button.addTarget(self, action: #selector(touchInCartButton), for: .touchUpInside)
        return button
    }()
    
    private (set) lazy var notifiButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.setImage(ImageManager.notification, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(touchInNotificationButton), for: .touchUpInside)
        return button
    }()

    
    private (set) lazy var cartBarButtonItem = UIBarButtonItem(customView: cartButton)
    private (set) lazy var notifiBarButtonItem = UIBarButtonItem(customView: notifiButton)
    private (set) lazy var tapGestureOnSuperView = UITapGestureRecognizer(target: self,
                                                                          action: #selector(touchInScrollView))
    
    lazy var emptyView: EmptyView = {
        let view = EmptyView()
        view.isHidden = true
        return view
    }()
    
    // MARK: - LifeCycles
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navCtrl = navigationController {
            navCtrl.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
        setupTabbar()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        view.backgroundColor = UIColor.white
        addTapOnSuperViewDismissKeyboard()
        setupUIComponents()
        handleDefaultNotification()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.reloadCartBadgeNumber,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    // MARK: - Override Methods
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - UI Actions
    
    @objc func touchUpInBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func touchUpInLeftBarButtonItem() {}
    
    @objc func touchUpInRightBarButtonItem() {}
    
    @objc func searchBarValueChange(_ textField: UITextField) {}
    
    @objc func touchInSearchBar() {}
    
    @objc func keyboardWillShow(_ notification: NSNotification) {}
    
    @objc func keyboardWillHide(_ notification: NSNotification) {}
    
    @objc func touchInScrollView() {
        view.endEditing(true)
    }
    
    @objc func touchInCartButton() {
        AppRouter.pushToCart()
    }
    
    @objc func touchInNotificationButton() {
        AppRouter.pushToNotificationVC()
    }
    
    // MARK: - Public methods
    
    func showLoading() {
        view.endEditing(true)
        hub.show(in: view)
    }
    
    func hideLoading() {
        hub.dismiss()
    }
    
    func presentDefaultErrorMessage() {
        AlertManager.shared.show(message: TextManager.errorMessage.localized())
    }
    
    func addTapOnSuperViewDismissKeyboard() {
        tapGestureOnSuperView.cancelsTouchesInView = false
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGestureOnSuperView)
    }
    
    func handleDefaultNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleCartBadgeChange),
                                               name: NSNotification.Name.reloadCartBadgeNumber,
                                               object: nil)
    }
    
    @objc func handleCartBadgeChange() {
        cartButton.badgeNumber = CartManager.shared.totalProducts
    }
    
    func addEmptyView(message: String? = nil, image: UIImage? = nil) {
        if message != nil {
            emptyView.message = message
        }
        if image != nil {
            emptyView.image = image
        }
        
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { (make) in
            make.width.height.equalTo(300)
            make.center.equalToSuperview()
        }
    }
    
    func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    // MARK: - Setup UI
    
    func setupUIComponents() {
        self.view.setDefaultBackgroundColor()
        self.setupTabbar()
        self.addBackButtonIfNeeded()
    }
    
    private func setupTabbar() {
        if navigationController?.viewControllers.count ?? 0 > 1 {
            tabBarController?.tabBar.isHidden = true
        } else {
            tabBarController?.tabBar.isHidden = false
        }
    }
    
    func addBackButtonIfNeeded() {
        let numberOfVC = navigationController?.viewControllers.count ?? 0
        guard numberOfVC > 1 else { return }
        let target: Target = (target: self, #selector(touchUpInBackButton))
        let barbuttonItemModel = BarButtonItemModel(ImageManager.back, target)
        navigationItem.leftBarButtonItem = buildBarButton(from: barbuttonItemModel)
    }
    
    func buildBarButton(from itemModel: BarButtonItemModel) -> UIBarButtonItem {
        let target = itemModel.target
        let customButton = UIButton(type: .custom)
        customButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        if itemModel.image != nil {
            let image = itemModel.image?.withRenderingMode(.alwaysTemplate)
            customButton.setImage(image, for: .normal)
            customButton.tintColor = UIColor.white
        } else if itemModel.title != nil {
            customButton.setTitle(itemModel.title!, for: .normal)
            customButton.setTitleColor(UIColor.white, for: .normal)
        }
        
        customButton.addTarget(target.target, action: target.selector, for: .touchUpInside)
        return UIBarButtonItem(customView: customButton)
    }
    
    func addBarItems(with itemModels: [BarButtonItemModel], type: BarButtonItemType = .right) {
        var barButtonItems: [UIBarButtonItem] = []
        itemModels.forEach {
            barButtonItems.append(buildBarButton(from: $0))
        }
        if type == .right {
            navigationItem.rightBarButtonItems = barButtonItems
        } else {
            navigationItem.leftBarButtonItems = barButtonItems
        }
    }
    
    func setDefaultNavigationBar(leftBarImage: UIImage? = nil, rightBarItem: UIImage? = nil) {
        if leftBarImage != nil {
            let leftBarItemTarget: Target = (target: self, selector: #selector(touchUpInLeftBarButtonItem))
            let leftBarButtonModel = BarButtonItemModel(leftBarImage, leftBarItemTarget)
            addBarItems(with: [leftBarButtonModel], type: .left)
        }
        
        if rightBarItem != nil {
            let rightBarItemTarget: Target = (target: self, selector: #selector(touchUpInRightBarButtonItem))
            let rightBarButtonModel = BarButtonItemModel(rightBarItem, rightBarItemTarget)
            addBarItems(with: [rightBarButtonModel], type: .right)
        }

        navigationItem.titleView = searchBar
    }
    
    func setRightNavigationBar(_ image: UIImage? = nil) {
        if image != nil {
            let rightBarItemTarget: Target = (target: self, selector: #selector(touchUpInRightBarButtonItem))
            let rightBarButtonModel = BarButtonItemModel(image, rightBarItemTarget)
            addBarItems(with: [rightBarButtonModel], type: .right)
        }
    }
    
    func setLeftNavigationBar(_ image: UIImage? = nil) {
        if image != nil {
            let leftBarItemTarget: Target = (target: self, selector: #selector(touchUpInLeftBarButtonItem))
            let leftBarButtonModel = BarButtonItemModel(image, leftBarItemTarget)
            addBarItems(with: [leftBarButtonModel], type: .left)
        }
    }
    
    func layoutScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
            }
            make.left.right.bottom.equalToSuperview()
        }
    }
    
}

// MARK: - UITextFieldDelegate

extension BaseViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
        return true
    }
}

// MARK: - UIGestureRecognizerDelegate

extension BaseViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
