//
//  UITableView+Extension.swift
//  Ecom
//
//  Created by Nguyen Dinh Trieu on 3/22/19.
//  Copyright © 2019 Minh Tri. All rights reserved.
//

import UIKit

public extension UITableView {
    func registerReusableCell<T: UITableViewCell>(_: T.Type) where T:Reusable {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func registerReusableHeaderFooter<T: UITableViewHeaderFooterView>(_: T.Type) where T: Reusable {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T:Reusable {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            return T()
        }
        return cell
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T where T: Reusable {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            return T()
        }
        return view
    }
}
