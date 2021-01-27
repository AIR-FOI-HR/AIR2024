//
//  ActivityCellItem.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 27.01.2021..
//

import UIKit


class DefaultActivityCellItem: ActivityCellItemProtocol {
    var activityId: Int
    var startTime: String
    var endTime: String
    var title: String
    var description: String
    var locationName: String?
    var latitude: Double?
    var longitude: Double?
    var temperature: Float?
    var feelsLike: Float?
    var wind: Float?
    var humidity: Int?
    var forecastType: String?
    var name: String
    var type: String
    var statusType: String
    var color: UIColor
    init(
        activityId: Int,
        startTime: String,
        endTime: String,
        title: String,
        description: String,
        locationName: String?,
        latitude: Double?,
        longitude: Double?,
        temperature: Float?,
        feelsLike: Float?,
        wind: Float?,
        humidity: Int?,
        forecastType: String?,
        name: String,
        type: String,
        statusType: String,
        color: UIColor
    ) {
        
        self.activityId = activityId
        self.startTime = startTime
        self.endTime = endTime
        self.title = title
        self.description = description
        self.locationName = locationName
        self.latitude = latitude
        self.longitude = longitude
        self.temperature = temperature
        self.feelsLike = feelsLike
        self.wind = wind
        self.humidity = humidity
        self.forecastType = forecastType
        self.name = name
        self.type = type
        self.statusType = statusType
        self.color = color
    }
}

class InProgressActivityCellItem: ActivityCellItemProtocol {
    var activityId: Int
    var startTime: String
    var endTime: String
    var title: String
    var description: String
    var locationName: String?
    var latitude: Double?
    var longitude: Double?
    var temperature: Float?
    var feelsLike: Float?
    var wind: Float?
    var humidity: Int?
    var forecastType: String?
    var name: String
    var type: String
    var statusType: String
    var color: UIColor
    init(
        activityId: Int,
        startTime: String,
        endTime: String,
        title: String,
        description: String,
        locationName: String?,
        latitude: Double?,
        longitude: Double?,
        temperature: Float?,
        feelsLike: Float?,
        wind: Float?,
        humidity: Int?,
        forecastType: String?,
        name: String,
        type: String,
        statusType: String,
        color: UIColor
    ) {
        
        self.activityId = activityId
        self.startTime = startTime
        self.endTime = endTime
        self.title = "IP:" + title
        self.description = description
        self.locationName = locationName
        self.latitude = latitude
        self.longitude = longitude
        self.temperature = temperature
        self.feelsLike = feelsLike
        self.wind = wind
        self.humidity = humidity
        self.forecastType = forecastType
        self.name = name
        self.type = type
        self.statusType = statusType
        self.color = color
    }
}

class PastActivityCellItem: ActivityCellItemProtocol {
    var activityId: Int
    var startTime: String
    var endTime: String
    var title: String
    var description: String
    var locationName: String?
    var latitude: Double?
    var longitude: Double?
    var temperature: Float?
    var feelsLike: Float?
    var wind: Float?
    var humidity: Int?
    var forecastType: String?
    var name: String
    var type: String
    var statusType: String
    var color: UIColor
    init(
        activityId: Int,
        startTime: String,
        endTime: String,
        title: String,
        description: String,
        locationName: String?,
        latitude: Double?,
        longitude: Double?,
        temperature: Float?,
        feelsLike: Float?,
        wind: Float?,
        humidity: Int?,
        forecastType: String?,
        name: String,
        type: String,
        statusType: String,
        color: UIColor
    ) {
        
        self.activityId = activityId
        self.startTime = startTime
        self.endTime = endTime
        self.title = "FF:" + title
        self.description = description
        self.locationName = locationName
        self.latitude = latitude
        self.longitude = longitude
        self.temperature = temperature
        self.feelsLike = feelsLike
        self.wind = wind
        self.humidity = humidity
        self.forecastType = forecastType
        self.name = name
        self.type = type
        self.statusType = statusType
        self.color = color
    }
}
