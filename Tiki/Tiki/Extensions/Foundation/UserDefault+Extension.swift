//
//  UserDefault+Extension.swift
//  Ecom
//
//  Created by MACOS on 4/11/19.
//  Copyright © 2019 Ecom. All rights reserved.
//

import Foundation

public extension UserDefaults {
    
    // MARK: - Helper type
    
    enum Key: String {
        case searchHistories = "searchHistories"
    }
    
    // MARK: - Get
    
    public func getObject<Value>(for key: UserDefaults.Key) -> Value? {
        let userDefaults = UserDefaults.standard
        return userDefaults.object(forKey: key.rawValue) as? Value
    }
    
    public func getObjects<Value>(for key: UserDefaults.Key) -> [Value]? {
        let userDefaults = UserDefaults.standard
        guard let array = userDefaults.array(forKey: key.rawValue) else { return nil }
        let results = array.map { $0 as? Value }
        return results as? [Value] ?? []
    }
    
    public func getCustomObject<Value: NSObject>(for key: UserDefaults.Key) -> Value? where Value: NSCoding {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.data(forKey: key.rawValue) else { return nil }
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? Value
    }
    
    // MARK: - Set
    
    public func setObject<Value>(for key: UserDefaults.Key, value: Value) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: key.rawValue)
    }
    
    public func setCustomObject<Value: NSObject>(for key: UserDefaults.Key, value: Value) where Value: NSCoding {
        let userDefaults = UserDefaults.standard
        let data = NSKeyedArchiver.archivedData(withRootObject: value)
        userDefaults.set(data, forKey: key.rawValue)
    }
    
}
