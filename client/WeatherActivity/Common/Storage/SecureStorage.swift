//
//  SecureStorage.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 01.12.2020..
//

import KeychainSwift

enum SecureStorageKey: String {
    case sessionToken = "sessionToken"
    case lastEnteredMail = "lastEnteredMail"
}

class SecureStorage {
    let keychain = KeychainSwift()
    
    func saveStringToKeychain(value: String, key: SecureStorageKey) {
        keychain.set(value, forKey: key.rawValue)
    }
    
    func getStringFromKeychain(key: SecureStorageKey) -> String? {
        return keychain.get(key.rawValue)
    }
    
    func deleteFromKeychain(key: SecureStorageKey) {
        keychain.delete(key.rawValue)
    }
}
