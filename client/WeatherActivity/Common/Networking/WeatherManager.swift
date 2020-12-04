//
//  ForecastService.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 04.12.2020..
//

// MARK: Imports 

import Alamofire

class WeatherManager {
    
    #warning("Date could be only 5 days later than today")
    func getWeatherForecast(date: Date, locationCoordinates: LocationDetails, success: @escaping (WeatherData)->Void, failure: @escaping (Error)->Void) {
        AF.request(
            Constants.weatherBaseUrlCoordinates.appending("&lat=\(locationCoordinates.latitude)&lon=\(locationCoordinates.longitude)") as URLConvertible,
            method: .get
        ).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let jsonData = try JSONDecoder().decode(WeatherData.self, from: data)
                    success(jsonData)
                } catch {
                    failure(error)
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
}
