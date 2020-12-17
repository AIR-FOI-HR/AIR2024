//
//  RegistrationUser.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 01.12.2020..
//

import Foundation

struct RegistrationUser: Codable {
    
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    let username: String
    let avatarId: Int
}

struct FirstStepRegistrationData {
    
    let firstName: String
    let lastName: String
    let email: String
    let password: String
}

struct SecondStepRegistrationData {
    
    let username: String
    let avatarId: Int
}

struct RegistrationData {
    let first: FirstStepRegistrationData?
    let second: SecondStepRegistrationData?
}
