//
//  SecureStorage.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 01.12.2020..
//

import KeychainSwift

enum SecureStorageKey: String {
    case sessionToken = "sessionToken"
}

class SecureStorage {
    let keychain = KeychainSwift()
    
    func saveToken(sessionToken token: String, keyType key: SecureStorageKey) {
        keychain.set(token, forKey: key.rawValue)
    }
    
    func getToken(keyType key: SecureStorageKey) -> String? {
        return keychain.get(key.rawValue)
    }
}
