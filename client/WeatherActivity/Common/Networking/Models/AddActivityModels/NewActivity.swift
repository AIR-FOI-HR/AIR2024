//
//  AddActivityModel.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 03.12.2020..
//

import MapKit

struct LocationDetails {
    var locationName: String
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
}

struct TimeDetails {
    var date: Date
    var fromTime: String
    var untilTime: String
}

struct ActivityData {
    var locationDetails: LocationDetails? = nil
    var timeDetails: TimeDetails? = nil
}
