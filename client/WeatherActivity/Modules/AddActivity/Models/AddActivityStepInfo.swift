//
//  AddActivityStepInfo.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 17.12.2020..
//

import UIKit

enum StepInfo: String {
    case locationDetails = "LocationDetails"
    case timeDetails = "TimeDetails"
    case categoryDetails = "CategoryDetails"
    case finalDetails = "FinalDetails"
}

struct StepData {
    let stepInfo: StepInfo
    let data: Codable
}
