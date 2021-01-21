//
//  ForecastService.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 04.12.2020..
//

// MARK: Imports 

import Alamofire

protocol ForecastServiceProtocol {
    func getWeatherForecast(date: Date, locationCoordinates: LocationDetails, success: @escaping (WeatherInfo)->Void, failure: @escaping (Error)->Void)
}

class ForecastService: ForecastServiceProtocol {
    
    func getWeatherForecast(date: Date, locationCoordinates: LocationDetails, success: @escaping (WeatherInfo)->Void, failure: @escaping (Error)->Void) {
        AF.request(
            Constants.weatherBaseUrlCoordinates.appending("&lat=\(locationCoordinates.latitude)&lon=\(locationCoordinates.longitude)") as URLConvertible,
            method: .get
        ).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let jsonData = try JSONDecoder().decode(WeatherInfo.self, from: data)
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

class AnotherForecastService: ForecastServiceProtocol {
    let url = "drugiWeatherAPI.com"
    func getWeatherForecast(date: Date, locationCoordinates: LocationDetails, success: @escaping (WeatherInfo) -> Void, failure: @escaping (Error) -> Void) {
        AF.request(
            url.appending("&lat=\(locationCoordinates.latitude)&lon=\(locationCoordinates.longitude)") as URLConvertible,
            method: .get
        ).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let jsonData = try JSONDecoder().decode(WeatherInfo.self, from: data)
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
