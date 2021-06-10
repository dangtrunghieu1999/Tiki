//
//  FilterCouponViewModel.swift
//  CustomerApp
//
//  Created by LAP12852 on 10/12/19.
//  Copyright © 2019 Bee. All rights reserved.
//

import Foundation

enum FilterProductType: Int {
    case all            = 0
    case popular        = 1
    case selling        = 2
    case news           = 3
    case cheapt         = 4
    case expensive      = 5
    
    var description: String {
        switch self {
        case .all:
            return TextManager.all.localized()
        case .popular:
            return TextManager.popular.localized()
        case .selling:
            return TextManager.selling.localized()
        case .news:
            return TextManager.newProduct.localized()
        case .cheapt:
            return TextManager.cheapt.localized()
        case .expensive:
            return TextManager.expensive.localized()
        }
    }
    
    static func numberOfItems() -> Int {
        return 6
    }
}

// MARK: -

class FilterCouponViewModel: NSObject {
    
    // MARK: - Varibles
    
    private (set) var selectedOrderTypes: [FilterProductType] = []
    
    // MARK: - Public methods
    
    /// Return Bool indicate should reload data
    @discardableResult
    func didSelectOrderType(_ orderType: FilterProductType) -> Bool {
        if orderType == .all {
            if self.selectedOrderTypes.contains(orderType) {
                return false
            } else {
                self.selectedOrderTypes.removeAll()
                self.selectedOrderTypes.append(orderType)
                return true
            }
        } else {
            if let index = self.selectedOrderTypes.firstIndex(of: .all) {
                self.selectedOrderTypes.remove(at: index)
                self.selectedOrderTypes.append(orderType)
                return true
            } else {
                if let selectedOrderIndex = self.selectedOrderTypes.firstIndex(of: orderType) {
                    if self.selectedOrderTypes.count > 1 {
                        self.selectedOrderTypes.remove(at: selectedOrderIndex)
                        return true
                    } else {
                        return false
                    }
                } else {
                    self.selectedOrderTypes.append(orderType)
                    return true
                }
            }
        }
    }
    
    func isSelectedCell(at indexPath: IndexPath) -> Bool {
        guard let orderType = FilterProductType(rawValue: indexPath.row) else {
            return false
        }
        return self.selectedOrderTypes.contains(orderType)
    }
    
}
