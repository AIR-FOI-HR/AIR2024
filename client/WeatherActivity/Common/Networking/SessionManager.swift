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

    func saveToken(_ value: String) {
        secureStorage.saveToken(sessionToken: value, keyType: .sessionToken)
    }

    func getToken() -> String? {
        return secureStorage.getToken(keyType: .sessionToken)
    }
    
    func deleteToken() {
        secureStorage.deleteToken(keyType: .sessionToken)
    }
}
