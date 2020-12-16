//
//  CategoryDetailsModel.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 16.12.2020..
//

struct CategoryDetailsModel: Codable {
    
    let category: String
    
    enum CodingKeys: String, CodingKey {
        case category
    }
}
