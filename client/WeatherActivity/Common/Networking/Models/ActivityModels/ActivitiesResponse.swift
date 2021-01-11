//
//  ActivitiesResponse.swift
//  WeatherActivity
//
//  Created by Infinum on 06.12.2020..
//

import Foundation

struct Activities: Codable {
    let activityId: Int
    let startTime: String
    let endTime: String
    let title: String
    let description: String
    let locationName: String
    let latitude: Double
    let longitude: Double
    let temperature: Float?
    let feelsLike: Float?
    let wind: Float?
    let humidity: Int?
    let forecastType: String?
    let name: String
    let type: String
    let statusType: String
}
