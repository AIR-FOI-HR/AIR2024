//
//  LocationDetailsModel.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 16.12.2020..
//

struct LocationDetailsModel: Codable {
    
    let latitude: String
    
    enum CodingKeys: String, CodingKey {
        case latitude
    }
}
