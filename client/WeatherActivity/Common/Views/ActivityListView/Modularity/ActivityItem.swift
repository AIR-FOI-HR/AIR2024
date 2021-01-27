//
//  ActivityItem.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 27.01.2021..
//

import UIKit

protocol ActivityCellItemProtocol {
    var activityId: Int { get }
    var startTime: String { get }
    var endTime: String { get }
    var title: String { get }
    var description: String { get }
    var locationName: String? { get }
    var latitude: Double? { get }
    var longitude: Double? { get }
    var temperature: Float? { get }
    var feelsLike: Float? { get }
    var wind: Float? { get }
    var humidity: Int? { get }
    var forecastType: String? { get }
    var name: String { get }
    var type: String { get }
    var statusType: StatusType { get }
}
