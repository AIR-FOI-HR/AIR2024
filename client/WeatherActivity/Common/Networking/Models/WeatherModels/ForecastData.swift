//
//  ForecastData.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 07.12.2020..
//

struct ForecastData {
    
    func getConditionImage(id: Int) -> String {
        var image: String {
            switch id {
            case 200...233:
                return "cloud.bolt.rain"
            case 300...321:
                return "cloud.drizzle"
            case 500...531:
                return "cloud.rain"
            case 600...622:
                return "cloud.snow"
            case 700...781:
                return "cloud.fog"
            case 800:
                return "sun.max"
            default:
                return "cloud.sun"
            }
        }
        return image
    }
}
