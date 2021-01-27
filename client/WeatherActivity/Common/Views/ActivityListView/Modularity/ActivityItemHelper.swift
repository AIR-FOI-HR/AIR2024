//
//  ActivityItemHelper.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 22.01.2021..
//

import UIKit

struct ActivityItemHelper {
    func getActivityCellItems(activities: [Activities]) -> [ActivityCellItemProtocol] {
        var activitiesItems = [ActivityCellItemProtocol]()
        if(activities.count == 1) {
            let activity = activities[0]
            let pActivity: ActivityCellItemProtocol = initCellItem(activity: activity)
            activitiesItems.append(pActivity)
        } else {
            for activity in activities {
                let pActivity: ActivityCellItemProtocol = initCellItem(activity: activity)
                activitiesItems.append(pActivity)
            }
        }
        return activitiesItems
    }
    
    func initCellItem(activity: Activities) -> ActivityCellItemProtocol{
        var initActivity: ActivityCellItemProtocol
        switch(activity.statusType) {
        case .inProgress:
            initActivity = InProgressActivityCellItem(activityId: activity.activityId, startTime: activity.startTime, endTime: activity.endTime, title: activity.title, description: activity.description, locationName: activity.locationName, latitude: activity.latitude, longitude: activity.longitude, temperature: activity.temperature, feelsLike: activity.feelsLike, wind: activity.wind, humidity: activity.humidity, forecastType: activity.forecastType, name: activity.name, type: activity.type, statusType: activity.statusType.rawValue, color: UIColor.systemGray)
            break;
        default:
            initActivity = DefaultActivityCellItem(activityId: activity.activityId, startTime: activity.startTime, endTime: activity.endTime, title: activity.title, description: activity.description, locationName: activity.locationName, latitude: activity.latitude, longitude: activity.longitude, temperature: activity.temperature, feelsLike: activity.feelsLike, wind: activity.wind, humidity: activity.humidity, forecastType: activity.forecastType, name: activity.name, type: activity.type, statusType: activity.statusType.rawValue, color: UIColor.systemBackground)
            break;
        }
        return initActivity
    }
    
}
