//
//  StandardStorage.swift
//  WeatherActivity
//
//  Created by Infinum on 20.12.2020..
//

import UIKit

enum StandardStorageKeys: String {
    case lastEnteredEmail = "LastEnteredEmail"
    case userName = "UserName"
}

class StandardStorage {
    let userDefaults = UserDefaults.standard
    
    func saveUserDefault(value: String, key: StandardStorageKeys) {
        userDefaults.set(value, forKey: key.rawValue)
    }
    
    func getUserDefaultString(key: StandardStorageKeys) -> String {
        guard let value = userDefaults.string(forKey: key.rawValue) else {
            return ""
        }
        return value
    }
}
