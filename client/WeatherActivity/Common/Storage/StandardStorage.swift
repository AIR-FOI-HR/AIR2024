//
//  StandardStorage.swift
//  WeatherActivity
//
//  Created by Infinum on 20.12.2020..
//

import UIKit

enum StandardStorageKeys: String {
    case firstTime = "FirstTime"
}

class StandardStorage {
    let userDefaults = UserDefaults.standard
    
    func saveUserDefault(value: Any, key: StandardStorageKeys) {
        userDefaults.set(value, forKey: key.rawValue)
    }
    
    func getUserDefaultBool(key: StandardStorageKeys) -> Bool {
        return userDefaults.bool(forKey: key.rawValue)
    }
    
    func deleteUserDefault(key: StandardStorageKeys) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
}
