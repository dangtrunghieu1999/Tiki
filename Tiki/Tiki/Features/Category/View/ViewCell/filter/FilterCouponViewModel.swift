//
//  FilterCouponViewModel.swift
//  CustomerApp
//
//  Created by LAP12852 on 10/12/19.
//  Copyright © 2019 Bee. All rights reserved.
//

import Foundation

enum FilterCouponOrderType: Int {
    case all            = 0
    case delivery       = 1
    case takeaway       = 2
    case reservation    = 3
    
    var description: String {
        switch self {
        case .all:
            return TextManager.all.localized()
        case .delivery:
            return TextManager.delivery.localized()
        case .takeaway:
            return TextManager.takeAway.localized()
        case .reservation:
            return TextManager.reservation.localized()
        }
    }
}

enum FilterCupponByValidation: Int {
    case all            = 0
    case available      = 1
    case nearExpired    = 2
    case expired        = 3
    
    var description: String {
        switch self {
        case .all:
            return TextManager.all.localized()
        case .available:
            return TextManager.available.localized()
        case .nearExpired:
            return TextManager.nearlyExpired.localized()
        case .expired:
            return TextManager.expired.localized()
        }
    }
}

// MARK: -

class FilterCouponViewModel: NSObject {
    
    // MARK: - Varibles
    
    private (set) var selectedOrderTypes: [FilterCouponOrderType] = []
    private (set) var selectedValidations: [FilterCupponByValidation] = []
    
    // MARK: - Public methods
    
    /// Return Bool indicate should reload data
    @discardableResult
    func didSelectOrderType(_ orderType: FilterCouponOrderType) -> Bool {
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
    
    /// Return Bool indicate should reload data
    @discardableResult
    func didSelectValidationType(_ validationType: FilterCupponByValidation) -> Bool {
        if validationType == .all {
            if self.selectedValidations.contains(validationType) {
                return false
            } else {
                self.selectedValidations.removeAll()
                self.selectedValidations.append(validationType)
                return true
            }
        } else {
            if let index = self.selectedValidations.firstIndex(of: .all) {
                self.selectedValidations.remove(at: index)
                self.selectedValidations.append(validationType)
                return true
            } else {
                if let selectedValidationIndex = self.selectedValidations.firstIndex(of: validationType) {
                    if self.selectedValidations.count > 1 {
                        self.selectedValidations.remove(at: selectedValidationIndex)
                        return true
                    } else {
                        return false
                    }
                } else {
                    self.selectedValidations.append(validationType)
                    return true
                }
            }
        }
    }
    
    func isSelectedCell(at indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            guard let orderType = FilterCouponOrderType(rawValue: indexPath.row) else {
                return false
            }
            return self.selectedOrderTypes.contains(orderType)
        } else {
            guard let validationType = FilterCupponByValidation(rawValue: indexPath.row) else {
                return false
            }
            return self.selectedValidations.contains(validationType)
        }
    }
    
}
