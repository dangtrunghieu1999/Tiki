//
//  URL+Extension.swift
//  Ecom
//
//  Created by Minh Tri on 4/6/19.
//  Copyright © 2019 Ecom. All rights reserved.
//

import UIKit

extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}
