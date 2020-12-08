//
//  ActivityService.swift
//  WeatherActivity
//
//  Created by Infinum on 06.12.2020..
//

import Foundation
import Alamofire

class ActivityService {
    
    func getActivities(token sessionToken: String, success: @escaping (ActivitiesResponse) -> Void, failure: @escaping (Error) -> Void) {
        AF.request(Constants.baseUrl.appending("/activity") as URLConvertible,
                   method: .post,
                   parameters: ["sessionToken": sessionToken],
                   encoder: JSONParameterEncoder.default
        ).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let jsonData = try JSONDecoder().decode(ActivitiesResponse.self, from: data)
                    success(jsonData)
                } catch (let error) {
                    failure(error)
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
}
