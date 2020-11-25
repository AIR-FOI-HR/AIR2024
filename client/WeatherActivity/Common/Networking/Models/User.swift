//
//  User.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 25.11.2020..
//

import Foundation

// class / struct

struct User: Decodable {
    let email: String
    let password: String
    let firstName: String
    let lastName: String
}
