//
//  ActivitiesResponse.swift
//  WeatherActivity
//
//  Created by Infinum on 06.12.2020..
//

import Foundation


enum StatusType: String, Codable {
    case inProgress = "In progress"
    case finished = "Finished"
    case future = "Future"
    case canceled = "Canceled"
    case completed = "Completed"
}

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
    let statusType: StatusType
}
 
public struct Activity: Codable, Identifiable {
    public let id: Int
    let startTime: String
    let title: String
    let locationName: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "activityId"
        case startTime = "startTime"
        case title = "title"
        case locationName = "locationName"
        case name = "name"
    }
}
 
extension Activity {
    var deepLinkUrl: URL {
        return URL(string: "\(Constants.widgetURLScheme)://\(id)")!
    }
}
