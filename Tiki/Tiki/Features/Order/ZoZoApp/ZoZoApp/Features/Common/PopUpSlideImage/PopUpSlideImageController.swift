//
//  PopUpSlideImageController.swift
//  Buyer
//
//  Created by MACOS on 11/19/18.
//  Copyright © 2018 Sendo.vn. All rights reserved.
//

import UIKit

protocol ProductSlideImageNewControllerDelegate: class {
    func scrollToItem(at index: Int)
}

class PopUpSlideImageController: BaseViewController {
    @IBOutlet var containerView:         UIView?
    @IBOutlet weak var collectionView:   UICollectionView?
    @IBOutlet weak var pageControl:      UIPageControl?
    @IBOutlet weak var productNameLabel: UILabel?
    @IBOutlet weak var pageLabel: UILabel?
    
    private var defaultAlpha: CGFloat       = 1.0
    private var collectionViewInitialCenter = CGPoint()
    private var imageURLs                   = [String]()
    private var currentPage                 = 0
    private var selectedIndexPath: IndexPath?
    
    weak var delegate: ProductSlideImageNewControllerDelegate?
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        collectionView?.delegate = self
        collectionView?.isUserInteractionEnabled = true
        collectionView?.registerReusableNibCell(ScrollImageCollectionViewCell.self)
        pageControl?.isHidden = (imageURLs.count < 2)
    }
    
    func setupData(selectedIndexPath: IndexPath?, urls: [String], productName: String) {
        imageURLs = urls
        collectionView?.reloadData()
        productNameLabel?.text = productName
        pageControl?.isHidden = (urls.count < 2)
        self.selectedIndexPath = selectedIndexPath
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if (urls.count > 6) {
                self.pageLabel?.isHidden = false
                self.pageControl?.isHidden = true
                let currentPage = (selectedIndexPath?.row ?? 0) + 1
                self.pageLabel?.text = "\(currentPage)/\(urls.count)"
            } else {
                self.pageLabel?.isHidden = true
                self.pageControl?.isHidden = false
                self.pageControl?.numberOfPages = urls.count
                self.pageControl?.currentPage = selectedIndexPath?.row ?? 0
            }
            
            guard let indexPath = selectedIndexPath else { return }
            if self.imageURLs.count > indexPath.item {
                self.collectionView?.scrollToItem(at: indexPath,
                                             at: .centeredHorizontally,
                                             animated: false)
            }
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismissViewController()
    }
    
    @IBAction func pageControlTapped(_ sender: UIPageControl) {
        let currentPage = sender.currentPage
        
        if currentPage < imageURLs.count {
            collectionView?.scrollToItem(at: IndexPath(item: currentPage, section: 0),
                                         at: .centeredHorizontally,
                                         animated: false)
        }
    }
    
    @IBAction func containerViewTapped(_ sender: UITapGestureRecognizer) {
        dismissViewController()
    }
    
    @IBAction func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let currentAlpha = defaultAlpha - abs(translation.y / ScreenSize.SCREEN_HEIGHT)
        containerView?.alpha = currentAlpha
        
        if sender.state == .began {
            collectionViewInitialCenter = collectionView?.center ?? CGPoint()
        } else if sender.state == .ended {
            updatePositionViewWhenEndDraging(with: translation.y)
        } else if sender.state == .cancelled {
            resetInitialPosition()
        } else {
            let newCenter = CGPoint(x: collectionViewInitialCenter.x, y: collectionViewInitialCenter.y + translation.y)
            collectionView?.center = newCenter
        }
    }
    
    private func dismissViewController() {
        dismiss(animated: true, completion: nil)
        delegate?.scrollToItem(at: currentPage)
    }
    
    private func resetInitialPosition() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.collectionView?.center = strongSelf.collectionViewInitialCenter
            strongSelf.containerView?.alpha = strongSelf.defaultAlpha
        }
    }
    
    private func updatePositionViewWhenEndDraging(with yTranslation: CGFloat) {
        guard let collectionView = collectionView else { return }
        
        if abs(yTranslation) >= ScreenSize.SCREEN_HEIGHT / 5 {
            var finalPoint = CGPoint()
            
            if yTranslation < 0 {
                finalPoint = CGPoint(x: collectionViewInitialCenter.x,
                                     y: -(collectionView.frame.height / 2))
                
            } else {
                let finalY = collectionView.frame.height / 2 + view.frame.height
                finalPoint = CGPoint(x: collectionViewInitialCenter.x, y: finalY)
            }
            
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { [weak self] in
                self?.collectionView?.center = finalPoint
            }) { [weak self] (_) in
                self?.dismissViewController()
            }
            
        } else {
            resetInitialPosition()
        }
    }
    
}

// MARL: - UICollectionViewDelegate

extension PopUpSlideImageController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPage = Int(scrollView.contentOffset.x / view.frame.width)
        
        if (imageURLs.count > 6) {
            pageLabel?.text = "\(currentPage + 1)/\(imageURLs.count)"
        } else {
            pageControl?.currentPage = currentPage
        }
    }
}

// MARK: - UICollectionViewDataSource

extension PopUpSlideImageController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ScrollImageCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.setupData(with: imageURLs[safe: indexPath.item])
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PopUpSlideImageController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
