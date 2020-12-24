//
//  Constants.swift
//  WeatherActivity
//
//  Created by Infinum on 27.11.2020..
//

import Foundation

struct Constants {
    
    // MARK: - Networking
    
    static let baseUrl = "http://seyziich.com:3100"
    
    // MARK: User Defaults
    
    static let lastEnteredEmail = "LastEnteredEmail"
    
    // MARK: Date time
    
    static let defaultTime = "16:00"
    static let defaultTimeInterval = 1
    static let defaultDateFormat = "dd-MM-yyyy"
    static let validDateRange = 5
    
    // MARK: Openweather API
    
    static let weatherApiKey = "02963ce30a9761093ff046cefdccaf73"
    static let weatherBaseUrlCoordinates = "http://api.openweathermap.org/data/2.5/forecast?units=metric&appid=".appending(weatherApiKey)
    static let weatherBaseUrlName = "http://api.openweathermap.org/data/2.5/forecast?units=metric&appid=".appending(weatherApiKey)
}
