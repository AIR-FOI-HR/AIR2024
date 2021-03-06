//
//  CategoryService.swift
//  WeatherActivity
//
//  Created by Infinum on 06.12.2020..
//

import Foundation
import Alamofire

class CategoryService {
    func getAllCategories(success: @escaping (CategoryResponse)->Void, failure: @escaping (Error)->Void) {
        AF.request(Constants.baseUrl.appending("/categories/allCategories"), parameters: nil, headers: nil
        ).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let jsonData = try JSONDecoder().decode(CategoryResponse.self, from: data)
                    success(jsonData)
                } catch (let error) {
                    failure(error)
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func getRecentCategories(token sessionToken: String, success: @escaping (CategoryResponse)->Void, failure: @escaping (Error)->Void) {
        AF.request(Constants.baseUrl.appending("/categories/recentCategories") as URLConvertible,
                   method: .post,
                   parameters: ["sessionToken": sessionToken],
                   encoder: JSONParameterEncoder.default
        ).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let jsonData = try JSONDecoder().decode(CategoryResponse.self, from: data)
                    success(jsonData)
                } catch (let error){
                    failure(error)
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
}
