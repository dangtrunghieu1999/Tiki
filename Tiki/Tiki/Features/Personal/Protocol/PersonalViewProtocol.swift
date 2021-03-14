//
//  PersonalViewProtocol.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/14/21.
//

import Foundation

protocol PersonalViewProtocol: class {
    
    func itemSelected(at: IndexPath)
    func numberOfItemSection()->Int
    func numberOfSections()->Int
    
}
