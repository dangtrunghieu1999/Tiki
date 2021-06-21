//
//  WardViewController.swift
//  Tiki
//
//  Created by Bee_MacPro on 19/06/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol WardViewControllerDelegate: class {
    func didTapDistrictSelect(_ ward: Ward,
                              code: String)
}

class WardViewController: AbstractLocationViewController {
    
    private (set) var wards: [Ward] = []
    weak var delegate: WardViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
    }
    
    func requestAPIWard(code: String) {
        
        let path = "https://api.mysupership.vn/v1/partner/areas/commune?district=" + code
        guard let url  = URL(string: path) else { return }
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case.success(let value):
                let json = JSON(value)
                let results = json["results"]
                self.wards = results.arrayValue.map{ Ward(json: $0) }
                self.reloadDataWhenFinishLoadAPI()
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension WardViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return wards.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LocationsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configCell(title: wards[indexPath.row].name)
        return cell
    }
}

extension WardViewController {
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        let name     = wards[indexPath.row].name
        let code     = wards[indexPath.row].code
        let ward     = wards[indexPath.row]
        
        self.delegate?.didTapDistrictSelect(ward, code: code)
        AlertManager.shared.showToast(message: name)
    }
}
