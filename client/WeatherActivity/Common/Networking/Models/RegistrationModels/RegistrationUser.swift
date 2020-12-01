//
//  RegistrationUser.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 01.12.2020..
//

struct RegistrationUser: Codable {
    var email: String
    var firstName: String
    var lastName: String
    var username: String?
    var password: String
    var avatarId: Int?
    
    init(userEmail email: String, userFirstName firstName: String, userLastName lastName: String, userPassword password: String) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.password = password
    }
    
}