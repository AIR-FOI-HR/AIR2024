//
//  AddActivityModel.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 03.12.2020..
//

import Foundation

struct NewActivity {
    
}

struct LocationDetails {
    
}

struct TimeDetails {
    var date: Date
    var fromTime: Date
    var untilTime: Date
}

struct ActivityData {
    var locationDetails: LocationDetails? = nil
    var timeDetails: TimeDetails? = nil
}
