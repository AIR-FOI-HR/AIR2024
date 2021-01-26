//
//  ActivityCell.swift
//  WeatherActivity
//
//  Created by Infinum on 06.12.2020..
//

import UIKit

protocol ActivityCellItemP {
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
    var statusType: String { get }
    var color: UIColor { get }
}

class DefaultActivityCellItem: ActivityCellItemP {
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

class InProgressActivityCellItem: ActivityCellItemP {
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

class CanceledActivityCellItem: ActivityCellItemP {
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
        self.title = "CANC:" + title
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

class FinishedActivityCellItem: ActivityCellItemP {
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

class ActivityCell: UITableViewCell {

    @IBOutlet weak private var activityTitle: UILabel!
    @IBOutlet weak private var activityLocation: UILabel!
    @IBOutlet weak private var activityTime: UILabel!
    @IBOutlet weak private var activityDate: UILabel!
    @IBOutlet weak private var activityImage: UIImageView!
    @IBOutlet weak private var cellBody: UIStackView!
    @IBOutlet weak private var progressBar: UIProgressView!

    func configure(with item: ActivityCellItemP) {
        let dateFormatter = DateFormatter()
        let dateTime = TimeDetailsManager().getCorrectDateAsString(from: item.startTime)
        guard let timestamp = dateTime else { return }
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.string(from: timestamp)
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.string(from: timestamp)
        cellBody.backgroundColor = item.color
        activityTitle.text = item.title
        activityLocation.text = item.locationName
        activityDate.text = date
        activityTime.text = time
        activityImage.image = UIImage(named: item.name.lowercased())
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let startDate = dateFormatter.date(from: item.startTime)!
        print(startDate)
        let duration = dateFormatter.date(from: item.endTime)!.timeIntervalSince(startDate)
        print(duration)
        let elapsed = dateFormatter.date(from: dateFormatter.string(from: Date()))!.timeIntervalSince(timestamp)
        print(elapsed)
        let percentage = elapsed / duration
    
        if(percentage >= 0 && percentage <= 1) {
            progressBar.progress = Float(percentage)
        } else {
            progressBar.isHidden = true
        }
    }
}
