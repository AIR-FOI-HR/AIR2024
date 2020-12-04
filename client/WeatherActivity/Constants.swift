//
//  Constants.swift
//  WeatherActivity
//
//  Created by Infinum on 27.11.2020..
//

import Foundation

struct Constants {
    
    // MARK: - Networking
    
    static let baseUrl = "http://localhost:3000"
    
    // MARK: User Defaults
    
    static let lastEnteredEmail = "LastEnteredEmail"
    
    // MARK: Date time
    
    static let defaultTime = "16:00"
    static let defaultTimeInterval = 1
    static let defaultDateFormat = "dd-MM-yyyy"
    
    // MARK: Openweather API
    
    static let weatherApiKey = "02963ce30a9761093ff046cefdccaf73"
    static let weatherBaseUrlCoordinates = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=".appending(weatherApiKey)
    static let weatherBaseUrlName = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=".appending(weatherApiKey)
}
