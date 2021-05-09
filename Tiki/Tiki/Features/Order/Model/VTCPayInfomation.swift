//
//  VTCPayInfomation.swift
//  ZoZoApp
//
//  Created by LAP12852 on 8/31/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

enum Currency: String {
    case VND = "VND"
    case USD = "USD"
}

class VTCPayInfomation {
    
    private (set) var transDate: String
    
    /**
     Mã ứng dụng lấy từ mục Quản trị tích hợp trên trang https:// pay.vtc.vn/
     */
    static let appID: Int = 500042051
    
    /**
     Mật khẩu kết nối lấy từ trường Mật khẩu kết nối khi tạo ứng dụng trên tích hợp mobile.
     */
    static let passConnect: String = "Atalike@123"
    
    /**
     Số điện thoại tạo tài khoản VTCPay để tạo ứng dụng chứa AppID.
     */
    static let accountName: String = "0988725702"
    
    private (set) var orderCode: String
    private (set) var amount: Double
    private (set) var currency: Currency
    private (set) var description: String
    private (set) var defaultLanguage: Int32
    
    init(_ orderCode: String) {
        self.transDate = Date().desciption(by: .VTCPay)
        self.orderCode = orderCode
        self.amount = OrderManager.shared.selectedCartShopInfo?.totalMoney ?? 0
        self.currency = .VND
        self.description = ""
        self.defaultLanguage = 0 // 0: VietNamese
    }
    
    func setCurrency(_ curency: Currency) {
        self.currency = curency
    }
}
