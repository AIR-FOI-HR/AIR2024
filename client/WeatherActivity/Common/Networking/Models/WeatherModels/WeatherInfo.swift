//
//  WeatherData.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 04.12.2020..
//

// MARK: - WeatherData API

struct WeatherInfo: Codable {
    
    let message, cnt: Int?
    let weatherList: [WeatherList]?
    let city: City?
    
    enum CodingKeys: String, CodingKey {
        case message, cnt, city
        case weatherList = "list"
    }
}

// MARK: - City

struct City: Codable {
    
    let id: Int?
    let name: String?
    let coord: Coord?
    let country: String?
    let population, timezone, sunrise, sunset: Int?
}

// MARK: - Coord

struct Coord: Codable {
    
    let lat, lon: Double?
}

// MARK: - List

struct WeatherList: Codable {

    let dateTime: Double?
    let main: MainWeatherInfo?
    let weather: [Weather]?
    let clouds: Clouds?
    let wind: Wind?
    let visibility: Int?

    enum CodingKeys: String, CodingKey {
        case dateTime = "dt"
        case main, weather, clouds, wind, visibility
    }
}

// MARK: - Clouds

struct Clouds: Codable {
    let all: Int?
}

// MARK: - MainClass

struct MainWeatherInfo: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, humidity: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
    }
}

// MARK: - Weather

struct Weather: Codable {
    let id: Int?
    let main: String?
    let weatherDescription: String?
    let icon: String?

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Wind

struct Wind: Codable {
    let speed: Double?
    let deg: Int?
}
