//
//  TimeDetailsModel.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 16.12.2020..
//

struct TimeDetailsModel: Codable {
    
    let time: String

    enum CodingKeys: String, CodingKey {
        case time
    }
}
