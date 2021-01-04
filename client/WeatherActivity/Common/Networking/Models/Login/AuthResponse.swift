//
//  AuthResponse.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 01.12.2020..
//

struct AuthResponse: Decodable {
    let sessionToken: String
    let userName: String
    let userAvatar: String
}
