//
//  UserUpdate.swift
//  WeatherActivity
//
//  Created by Infinum on 22.01.2021..
//

import Foundation

struct UserUpdate: Codable {
    
    let firstName: String
    let lastName: String
    let username: String
    let avatarId: Int
    let sessionToken: String
}
