//
//  LocationViewController.swift
//  Tiki
//
//  Created by Bee_MacPro on 18/06/2021.
//

import UIKit
protocol LocationViewControllerDelegate: class {
    func finishSelectLocation(_ deliveryInfo: DeliveryInformation)
}

class LocationViewController: BaseViewController {
    
    // MARK: - Variables
    
    private lazy var viewControllerFrame = CGRect(x: 0,
                                                  y: 0,
                                                  width: view.bounds.width,
                                                  height: view.bounds.height)
    
    var parameters: [CAPSPageMenuOption] = [
        .centerMenuItems(true),
        .scrollMenuBackgroundColor(UIColor.white),
        .selectionIndicatorColor(UIColor.primary),
        .selectedMenuItemLabelColor(UIColor.bodyText),
        .menuItemFont(UIFont.systemFont(ofSize: FontSize.h2.rawValue, weight: .medium)),
        .menuHeight(42),
        .bottomMenuHairlineColor(UIColor.separator)
    ]
    
    weak var delegate: LocationViewControllerDelegate?
    private var deliveryInformation  = DeliveryInformation()
    fileprivate let provinceVC = ProvinceViewController()
    fileprivate let districtVC = DistrictViewController()
    fileprivate let wardVC     = WardViewController()

    var pageMenu : CAPSPageMenu?
    var numberIndex = 0
    
    fileprivate var subPageControllers: [AbstractLocationViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = TextManager.locationRecive
        addChildsVC()
    }
    
    fileprivate func addChildsVC() {
        addProvinceVC()
        addDistrictVC()
        addWardVC()
        
        pageMenu = CAPSPageMenu(viewControllers: subPageControllers,
                                frame: CGRect(x: 0.0, y: self.topbarHeight,
                                width: self.view.frame.width,
                                height: self.view.frame.height),
                                pageMenuOptions: parameters)
        self.view.addSubview(pageMenu!.view)
    }
    
    private func addProvinceVC() {
        provinceVC.delegate = self
        provinceVC.title = TextManager.provinceCity
        provinceVC.view.frame = viewControllerFrame
        subPageControllers.append(provinceVC)
    }
    
    private func addDistrictVC() {
        districtVC.delegate = self
        districtVC.title = TextManager.district
        districtVC.view.frame = viewControllerFrame
        subPageControllers.append(districtVC)
    }
    
    private func addWardVC() {
        wardVC.delegate = self
        wardVC.title = TextManager.ward
        wardVC.view.frame = viewControllerFrame
        subPageControllers.append(wardVC)
    }

}

// MARK: - ProvinceViewControllerDelegate

extension LocationViewController: ProvinceViewControllerDelegate {
    func didTapProvinceSelect(_ province: Province,
                              index: Int,
                              code: String) {
        self.deliveryInformation.province = province
        self.pageMenu?.moveToPage(index)
        self.districtVC.requestAPIDistrict(code: code)
    }
}

// MARK: - DistrictViewControllerDelegate

extension LocationViewController: DistrictViewControllerDelegate {
    func didTapDistrictSelect(_ district: District,
                              index: Int,
                              code: String) {
        self.deliveryInformation.district = district
        self.pageMenu?.moveToPage(index)
        self.wardVC.requestAPIWard(code: code)
    }
}

// MARK: - WardViewControllerDelegate

extension LocationViewController: WardViewControllerDelegate {
    
    func didTapDistrictSelect(_ ward: Ward, code: String) {
        self.deliveryInformation.ward = ward
        self.navigationController?.popViewControllerWithHandler(completion: {
            self.delegate?.finishSelectLocation(self.deliveryInformation)
        })
    }
}
