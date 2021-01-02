//
//  CategoryDetailsModel.swift
//  WeatherActivity
//
//  Created by Infinum on 18.12.2020..
//

import Foundation


struct Category: Codable {
    let categoryName: AllCategories
}

enum AllCategories: String, Codable, CaseIterable {
    case cinema = "Cinema"
    case climbing = "Climbing"
    case cooking = "Cooking"
    case driving = "Driving"
    case eating = "Eating"
    case farming = "Farming"
    case fishing = "Fishing"
    case gardening = "Gardening"
    case music = "Music"
    case pets = "Pets"
    case programming = "Programming"
    case running = "Running"
    case sleeping = "Sleeping"
    case socializing = "Socializing"
    case sports = "Sports"
    case tv = "TV"
    case videogames = "Videogames"
    case walking = "Walking"
}
