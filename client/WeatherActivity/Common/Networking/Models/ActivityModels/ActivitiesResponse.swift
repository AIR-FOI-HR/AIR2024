//
//  ActivitiesResponse.swift
//  WeatherActivity
//
//  Created by Infinum on 06.12.2020..
//

import Foundation

struct ActivitiesResponse: Codable {
    let data: [Activity]
}

struct Activity: Codable {
    let activityId: Int
    let startTime: String
    let endTime: String
    let title: String
    let description: String
    let locationName: String
    let forecastId: Int
    let categoryId: Int
    let activityStatusId: Int
}
