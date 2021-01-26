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
        if(activities.count == 1) {
            let activity = activities[0]
            let pActivity: ActivityCellItemP = initCellItem(activity: activity)
            activitiesItems.append(pActivity)
        } else {
            for activity in activities {
                let pActivity: ActivityCellItemP = initCellItem(activity: activity)
                activitiesItems.append(pActivity)
            }
        }
        return activitiesItems
    }
    
    func initCellItem(activity: Activities) -> ActivityCellItemP{
        var initActivity: ActivityCellItemP
        switch(activity.statusType) {
        case .inProgress:
            initActivity = InProgressActivityCellItem(activityId: activity.activityId, startTime: activity.startTime, endTime: activity.endTime, title: activity.title, description: activity.description, locationName: activity.locationName, latitude: activity.latitude, longitude: activity.longitude, temperature: activity.temperature, feelsLike: activity.feelsLike, wind: activity.wind, humidity: activity.humidity, forecastType: activity.forecastType, name: activity.name, type: activity.type, statusType: activity.statusType.rawValue, color: UIColor.systemGray)
            break;
        case .finished:
            initActivity = FinishedActivityCellItem(activityId: activity.activityId, startTime: activity.startTime, endTime: activity.endTime, title: activity.title, description: activity.description, locationName: activity.locationName, latitude: activity.latitude, longitude: activity.longitude, temperature: activity.temperature, feelsLike: activity.feelsLike, wind: activity.wind, humidity: activity.humidity, forecastType: activity.forecastType, name: activity.name, type: activity.type, statusType: activity.statusType.rawValue, color: UIColor.systemGray)
        default:
            initActivity = DefaultActivityCellItem(activityId: activity.activityId, startTime: activity.startTime, endTime: activity.endTime, title: activity.title, description: activity.description, locationName: activity.locationName, latitude: activity.latitude, longitude: activity.longitude, temperature: activity.temperature, feelsLike: activity.feelsLike, wind: activity.wind, humidity: activity.humidity, forecastType: activity.forecastType, name: activity.name, type: activity.type, statusType: activity.statusType.rawValue, color: UIColor.blue)
            break;
        }
        return initActivity
    }
    
}
