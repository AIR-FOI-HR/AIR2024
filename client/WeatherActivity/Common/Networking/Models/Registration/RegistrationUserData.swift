//
//  RegistrationUserData.swift
//  WeatherActivity
//
//  Created by Infinum on 17.12.2020..
//

import Foundation

struct UserInformation {
    
    let firstName: String
    let lastName: String
    let email: String
    let password: String
}

struct UserPreferences {
    
    let username: String
    let avatarId: Int
}

struct RegistrationData {
    
    let first: UserInformation?
    let second: UserPreferences?
}
