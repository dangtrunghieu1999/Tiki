//
//  DistrictViewController.swift
//  Tiki
//
//  Created by Bee_MacPro on 19/06/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol DistrictViewControllerDelegate: class {
    func didTapDistrictSelect(_ district: District,
                              index: Int,
                              code: String)
}

class DistrictViewController: AbstractLocationViewController {

    private (set) var districts: [District] = []
    weak var delegate: DistrictViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
    }

    func requestAPIDistrict(code: String) {
        let path = "https://api.mysupership.vn/v1/partner/areas/district?province=" + code
        guard let url  = URL(string: path) else { return }
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case.success(let value):
                let json = JSON(value)
                let results = json["results"]
                self.districts = results.arrayValue.map{ District(json: $0) }
                self.reloadDataWhenFinishLoadAPI()
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension DistrictViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return districts.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LocationsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configCell(title: districts[indexPath.row].name)
        cell.backgroundColor = UIColor.white
        return cell
    }
}

// MARK: - Override

extension DistrictViewController {
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        
        let name     = districts[indexPath.row].name
        let code     = districts[indexPath.row].code
        let district = districts[indexPath.row]
        
        self.delegate?.didTapDistrictSelect(district,
                                            index: 2,
                                            code: code)
        
        AlertManager.shared.showToast(message: name)
    }
    
}

