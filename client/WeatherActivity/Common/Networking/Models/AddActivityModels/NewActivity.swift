//
//  AddActivityModel.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 03.12.2020..
//

import MapKit

struct LocationDetails: Codable {
    let locationName: String
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
}

struct TimeDetails: Codable {
    let date: Date
    let fromTime: String
    let untilTime: String
}

struct FinalDetails: Codable {
    let title: String
    let description: String
    let typeOfActivity: Int
    let supportedWeather: [String]
}

struct CategoryDetails: Codable {
    let selectedCategory: String
}
