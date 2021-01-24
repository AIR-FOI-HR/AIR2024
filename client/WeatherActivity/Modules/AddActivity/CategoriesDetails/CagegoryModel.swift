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
    case food = "Food"
    case sports = "Sports"
    case family = "Family"
    case romance = "Romance"
    case business = "Business"
    case studying = "Studying"
    case shopping = "Shopping"
    case entertainment = "Entertainment"
    case uncategorized = "Uncategorized"
}
