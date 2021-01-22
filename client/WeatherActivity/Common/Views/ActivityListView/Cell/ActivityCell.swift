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
    var locationName: String { get }
    var latitude: Double { get }
    var longitude: Double { get }
    var temperature: Float? { get }
    var feelsLike: Float? { get }
    var wind: Float? { get }
    var humidity: Int? { get }
    var forecastType: String? { get }
    var name: String { get }
    var type: String { get }
    var statusType: String { get }
}

class CustomActivityCellItem: ActivityCellItemP {
    var activityId: Int
    var startTime: String
    var endTime: String
    var title: String
    var description: String
    var locationName: String
    var latitude: Double
    var longitude: Double
    var temperature: Float?
    var feelsLike: Float?
    var wind: Float?
    var humidity: Int?
    var forecastType: String?
    var name: String
    var type: String
    var statusType: String
    
    init(
        activityId: Int,
        startTime: String,
        endTime: String,
        title: String,
        description: String,
        locationName: String,
        latitude: Double,
        longitude: Double,
        temperature: Float?,
        feelsLike: Float?,
        wind: Float?,
        humidity: Int?,
        forecastType: String?,
        name: String,
        type: String,
        statusType: String
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
    }
}

class MyCustomActivityCellItem: ActivityCellItemP {
    var activityId: Int
    var startTime: String
    var endTime: String
    var title: String
    var description: String
    var locationName: String
    var latitude: Double
    var longitude: Double
    var temperature: Float?
    var feelsLike: Float?
    var wind: Float?
    var humidity: Int?
    var forecastType: String?
    var name: String
    var type: String
    var statusType: String
    
    init(
        activityId: Int,
        startTime: String,
        endTime: String,
        title: String,
        description: String,
        locationName: String,
        latitude: Double,
        longitude: Double,
        temperature: Float?,
        feelsLike: Float?,
        wind: Float?,
        humidity: Int?,
        forecastType: String?,
        name: String,
        type: String,
        statusType: String
    ) {
        
        self.activityId = activityId
        self.startTime = startTime
        self.endTime = endTime
        self.title = "Mod tit: " + title
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
    }
}

//struct ActivityCellItem {
//    let activityId: Int
//    let startTime: String
//    let endTime: String
//    let title: String
//    let description: String
//    let locationName: String
//    let latitude: Double
//    let longitude: Double
//    let temperature: Float?
//    let feelsLike: Float?
//    let wind: Float?
//    let humidity: Int?
//    let forecastType: String?
//    let name: String
//    let type: String
//    let statusType: String
//}

class ActivityCell: UITableViewCell {

    @IBOutlet weak private var activityTitle: UILabel!
    @IBOutlet weak private var activityLocation: UILabel!
    @IBOutlet weak private var activityTime: UILabel!
    @IBOutlet weak private var activityDate: UILabel!
    @IBOutlet weak private var activityImage: UIImageView!
    
    func configure(with item: ActivityCellItemP) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let timestamp = dateFormatter.date(from: item.startTime)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.string(from: timestamp!)
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.string(from: timestamp!)
        
        activityTitle.text = item.title
        activityLocation.text = item.locationName
        activityDate.text = date
        activityTime.text = time
        activityImage.image = UIImage(named: item.name.lowercased())
    }
}
