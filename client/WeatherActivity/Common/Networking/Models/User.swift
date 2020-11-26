//
//  User.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 25.11.2020..
//

import UIKit

/*
 * User structure
 */

struct User: Codable {
    var email: String = "Asd"
    var username: String
    var password: String
    var firstName: String
    var lastName: String
    var deviceToken: String
    var avatar: String
    
    // Additional addition as needed
    enum CodingKeys: String, CodingKey {
        case email = "mail"
        case username = "user"
        case password, firstName, lastName, deviceToken
        case avatar = "avatarId"
    }
}
