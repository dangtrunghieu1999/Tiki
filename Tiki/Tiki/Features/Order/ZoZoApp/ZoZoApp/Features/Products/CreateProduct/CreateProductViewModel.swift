//
//  CreateProductViewModel.swift
//  ZoZoApp
//
//  Created by MACOS on 7/5/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class CreateProductViewModel: BaseViewModel {
    
    private (set) var categories: [Category] = []
    private (set) var suppliers: [Supplier] = []

    override func initialize() {}
    
    func getAllCategories(completion: @escaping (() -> Void), onError: @escaping () -> Void) {
        let endPoint = ProductEndPoint.getAllCategory
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            guard let self = self else { return }
            self.categories = apiResponse.toArray([Category.self])
            completion()
        }, onFailure: { (apiError) in
            onError()
        }) {
            onError()
        }
    }
    
    func getAllSupplier(completion: @escaping () -> Void, onError: @escaping () -> Void) {
        let endPoint = ProductEndPoint.getAllSuplier
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            if let suppliers = apiResponse.data?["Records"].arrayValue.map({ Supplier(json: $0) }) {
                guard let self = self else { return }
                self.suppliers = suppliers
                completion()
            }
        }, onFailure: { (apiError) in
            onError()
        }) {
            onError()
        }
    }
    
}
