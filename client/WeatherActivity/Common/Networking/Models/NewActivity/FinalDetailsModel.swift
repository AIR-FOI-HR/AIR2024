//
//  FinalDetailsModel.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 16.12.2020..
//

struct FinalDetailsModel: Codable {
    
    let latitude: String

    enum CodingKeys: String, CodingKey {
        case latitude
    }
}

