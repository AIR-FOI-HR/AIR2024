//
//  SessionManager.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 01.12.2020..
//

// MARK: Singleton class

class SessionManager {
    
    // MARK: Public properties
    
    static let shared = SessionManager()
    
    // MARK: Private properties

    private let secureStorage = SecureStorage()

    // MARK: Public methods

    func saveStringToKeychain(value: String, key: SecureStorageKey) {
        secureStorage.saveStringToKeychain(value: value, key: key)
    }

    func getStringFromKeychain(key: SecureStorageKey) -> String? {
        return secureStorage.getStringFromKeychain(key: key)
    }
    
    func deleteFromKeychain(key: SecureStorageKey) {
        secureStorage.deleteFromKeychain(key: key)
    }
}
