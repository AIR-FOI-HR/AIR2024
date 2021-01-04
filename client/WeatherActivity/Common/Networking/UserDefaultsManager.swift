//
//  UserDefaultsManager.swift
//  WeatherActivity
//
//  Created by Infinum on 20.12.2020..
//

// MARK: Singleton class

class UserDefaultsManager {
    
    // MARK: Public properties
    
    static let shared = UserDefaultsManager()
    
    // MARK: Private properties

    private let standardStorage = StandardStorage()

    // MARK: Public methods
    
    func saveUserDefault(value: Any, key: StandardStorageKeys) {
        standardStorage.saveUserDefault(value: value, key: key)
    }
    
    func getUserDefaultBool(key: StandardStorageKeys) -> Bool {
        return standardStorage.getUserDefaultBool(key: key)
    }
    
    func getUserDefaultString(key: StandardStorageKeys) -> String {
        return standardStorage.getUserDefaultString(key: key)
    }
    
    func deleteUserDefault(key: StandardStorageKeys) {
        standardStorage.deleteUserDefault(key: key)
    }
}
