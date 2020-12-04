//
//  WeatherData.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 04.12.2020..
//

struct WeatherData: Codable {
    let name: String
    let main: Main
}

struct Main: Codable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
    let humidity: Double
}

