//
//  RegistrationUser.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 01.12.2020..
//

import Foundation

// MARK: Singleton for registrating user
class RegistrationUser: Codable {
    private init() {}
    
    static let registrationUser = RegistrationUser()
    
    var email: String?
    var firstName: String?
    var lastName: String?
    var username: String?
    var password: String?
    var avatar: Int?
}
