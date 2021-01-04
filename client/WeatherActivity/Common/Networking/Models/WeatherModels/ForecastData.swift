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
    
    func getConditionId(id: Int) -> Int {
        switch id {
        case 800:
            return 1
        case 803...804:
            return 2
        case 802:
            return 3
        case 300...531:
            return 4
        case 701...741:
            return 5
        case 600-622:
            return 6
        case 200...232:
            return 7
        default:
            return 8
        }
    }
}
