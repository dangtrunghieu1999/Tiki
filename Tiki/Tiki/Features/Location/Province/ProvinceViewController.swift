//
//  PrivinceViewController.swift
//  Tiki
//
//  Created by Bee_MacPro on 19/06/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol ProvinceViewControllerDelegate: class {
    func didTapProvinceSelect(_ province: Province,
                              index: Int,
                              code: String)
}

class ProvinceViewController: AbstractLocationViewController {

    private (set) var provinces:    [Province] = []
    weak var delegate: ProvinceViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
    }
 
    override func requestAPILocations() {
        let path = "https://api.mysupership.vn/v1/partner/areas/province"
        guard let url  = URL(string: path) else { return }
       
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case.success(let value):
                let json = JSON(value)
                let results = json["results"]
                self.provinces = results.arrayValue.map{ Province(json: $0) }
                self.reloadDataWhenFinishLoadAPI()
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension ProvinceViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return provinces.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LocationsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configCell(title: provinces[indexPath.row].name)
        return cell
    }
}

// MARK: - Override

extension ProvinceViewController {
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        let title    = provinces[indexPath.row].name
        let code     = provinces[indexPath.row].code
        let province = provinces[indexPath.row]
        AlertManager.shared.showToast(message: title)
        delegate?.didTapProvinceSelect(province,
                                       index: 1,
                                       code: code)
    }
    
}
