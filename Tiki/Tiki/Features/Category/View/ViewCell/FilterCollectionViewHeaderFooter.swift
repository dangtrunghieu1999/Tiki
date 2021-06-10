//
//  FilerCollectionViewHeaderFooter.swift
//  Tiki
//
//  Created by Bee_MacPro on 09/06/2021.
//

import UIKit

class FilterCollectionViewHeaderFooter: BaseCollectionViewHeaderFooterCell {
    
    let pulleyView: FilterCouponPulleyView = {
        let view = FilterCouponPulleyView()
        return view
    }()

    override func initialize() {
        super.initialize()
    }
}
