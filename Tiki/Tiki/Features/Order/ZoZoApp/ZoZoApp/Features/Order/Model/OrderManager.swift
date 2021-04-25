//
//  OrderManager.swift
//  ZoZoApp
//
//  Created by LAP12852 on 8/17/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class OrderManager {
    
    // MARK: - Variables
    
    static let shared = OrderManager()
    
    private (set) var orderCode: Int?
    
    var selectedCartShopInfo: CartShopInfo?
    var shippingFeeInfo                         = ShippingFeeInfor()
    var transporterType: TransportersType       = .giaoHangTietKiem
    var paymentMethod: PaymentMethodType        = .cash
    private (set) var deliveryInformation       : DeliveryInformation?
    
    var totalPaymentMoney: Double {
        return (selectedCartShopInfo?.totalMoney ?? 0) + shippingFeeInfo.fee
    }
    
    var deliveryDate: Date {
        return shippingFeeInfo.deliverDate
    }
    
    private let deliveryInfoKey = "com.alalike.deliveryInfoKey"
    
    // MARK: - Life cycles
    
    private init() {
        loadDeliveryInfoToUserDefault()
    }
    
    // MARK: - Public methods
    
    func setDeliveryInfomation(_ data: DeliveryInformation?) {
        deliveryInformation = data
        saveDeliveryInfoToUserDefault()
    }
    
    func saveDeliveryInfoToUserDefault() {
        guard let deliveryInfo = deliveryInformation else { return }
        let data = NSKeyedArchiver.archivedData(withRootObject: deliveryInfo)
        UserDefaults.standard.set(data, forKey: deliveryInfoKey)
    }
    
    func loadDeliveryInfoToUserDefault() {
        let data = UserDefaults.standard.data(forKey: deliveryInfoKey)
        if let data = data {
            deliveryInformation = NSKeyedUnarchiver.unarchiveObject(with: data) as? DeliveryInformation
        }
    }
    
    // MARK: - APIs Request
    
    func getAPIShippingFee(completion: @escaping () -> Void, error: @escaping () -> Void) {
        switch transporterType {
        case .giaoHangTietKiem:
            getAPIShippingFeeGHTK(completion: completion, error: error)
            break
        case .VNPost:
            getAPIShippingFeeVNPost(completion: completion, error: error)
            break
        }
    }
    
    private func getAPIShippingFeeGHTK(completion: @escaping () -> Void, error: @escaping () -> Void) {
        guard let shopInfo = selectedCartShopInfo,
            let deliveryInfo = deliveryInformation else {
                error()
                return
        }
        
        let shippingInfoParam: Parameters =
            ["pick_province": shopInfo.provinveName,
             "pick_district": shopInfo.districtName,
             "province": deliveryInfo.province?.name ?? "",
             "district": deliveryInfo.district?.name ?? "",
             "address": deliveryInfo.address,
             "weight": shopInfo.totalWeight,
             "value": shopInfo.totalMoney,
             "transport": "road"]
    
        let endPoint = OrderEndPoint.getShippingFeeGHTK(params: shippingInfoParam)
        APIService.requestByJSONString(endPoint: endPoint, onSuccess: { (apiResponse) in
            if let data = apiResponse.data {
                self.shippingFeeInfo = ShippingFeeInfor(forGHTK: data)
                completion()
            } else {
                error()
            }
        }, onFailure: { (apiError) in
            error()
        }) {
            error()
        }
    }
    
    private func getAPIShippingFeeVNPost(completion: () -> Void, error: () -> Void) {
        
    }
    
    func submitOrder(completion: @escaping () -> Void, error: @escaping () -> Void) {
        guard let cartShopInfo = selectedCartShopInfo,
            let userId = UserManager.userId,
            let deliveryInformation = deliveryInformation else {
            error()
            return
        }
        
        var params: Parameters = ["UserId":             userId,
                                  "ShopId":             cartShopInfo.id,
                                  "TotalAmount":        totalPaymentMoney,
                                  "PaymentMethodId":    paymentMethod.rawValue,
                                  "ShipId":             transporterType.rawValue,
                                  "ShipingFee":         shippingFeeInfo.fee,
                                  "InsuranceFee":       shippingFeeInfo.insuranceFee,
                                  "CustomerName":       deliveryInformation.fullName,
                                  "Phone":              deliveryInformation.phoneNumber,
                                  "Address":            deliveryInformation.address,
                                  "ProvinceId":         deliveryInformation.province?.id ?? 0,
                                  "DistrictId":         deliveryInformation.district?.id ?? 0,
                                  "WardId":             deliveryInformation.ward?.id ?? 0,
                                  "Email":              deliveryInformation.email]
        
        let listOrderProducts = cartShopInfo.products.map({ $0.toOrderDictionary() })
        params["ListOrderDetail"] = listOrderProducts
        
        let endPoint = OrderEndPoint.createOrder(params: params)
        APIService.request(endPoint: endPoint, onSuccess: { (apiResponse) in
            if let orderCode = apiResponse.data?.intValue {
                self.orderCode = orderCode
                completion()
            } else {
                error()
            }
        }, onFailure: { (apiError) in
            error()
        }) {
            error()
        }
    }
    
}
