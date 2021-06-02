//
//  HomeViewModel.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/8/21.
//

import UIKit

class HomeViewModel: NSObject {
    
    var products: [Product?] = []
    
    func getHomeBanner(completion: (([Home], ServiceErrorAPI?) -> Void)?) {
        let endPoint = HomeEndPoint.getAllHome
        
        APIService.request(endPoint: endPoint) { (apiResponse) in
            let homeModel = apiResponse.toArray([Home.self])
            completion?(homeModel, nil)
        } onFailure: { (apiError) in
            
        } onRequestFail: {
            
        }
        
    }
}
