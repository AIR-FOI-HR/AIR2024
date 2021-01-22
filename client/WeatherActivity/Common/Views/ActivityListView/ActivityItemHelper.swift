//
//  ActivityItemHelper.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 22.01.2021..
//

import UIKit

struct ActivityItemHelper {
    func getActivityCellItems(activities: [Activities]) -> [ActivityCellItemP] {
        var activitiesItems = [ActivityCellItemP]()
        for activity in activities {
            var pActivity: ActivityCellItemP
            switch(activity.statusType) {
            case .inProgress:
                pActivity = InProgressActivityCellItem(activityId: activity.activityId, startTime: activity.startTime, endTime: activity.endTime, title: activity.title, description: activity.description, locationName: activity.locationName, latitude: activity.latitude, longitude: activity.longitude, temperature: activity.temperature, feelsLike: activity.feelsLike, wind: activity.wind, humidity: activity.humidity, forecastType: activity.forecastType, name: activity.name, type: activity.type, statusType: activity.statusType.rawValue)
                break;
            default:
                pActivity = DefaultActivityCellItem(activityId: activity.activityId, startTime: activity.startTime, endTime: activity.endTime, title: activity.title, description: activity.description, locationName: activity.locationName, latitude: activity.latitude, longitude: activity.longitude, temperature: activity.temperature, feelsLike: activity.feelsLike, wind: activity.wind, humidity: activity.humidity, forecastType: activity.forecastType, name: activity.name, type: activity.type, statusType: activity.statusType.rawValue)
            }
            activitiesItems.append(pActivity)
        }
        return activitiesItems
    }
}
