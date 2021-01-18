//
//  ActivityService.swift
//  WeatherActivity
//
//  Created by Infinum on 06.12.2020..
//

import Foundation
import Alamofire

class ActivityService {
    
    func getActivities(token sessionToken: String, success: @escaping ([Activities]) -> Void, failure: @escaping (Error) -> Void) {
        AF.request(Constants.baseUrl.appending("/activity") as URLConvertible,
                   method: .post,
                   parameters: ["sessionToken": sessionToken],
                   encoder: JSONParameterEncoder.default
        ).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let jsonData = try JSONDecoder().decode([Activities].self, from: data)
                    success(jsonData)
                } catch (let error) {
                    failure(error)
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func getWidgetActivityDetails(activity id: Int, success: @escaping (Activities) -> Void, failure: @escaping (Error) -> Void) {
        AF.request(Constants.baseUrl.appending("/activity/widgetActivityDetails/\(id)") as URLConvertible,
                   method: .post,
                   parameters: ["sessionToken": SessionManager.shared.getToken()],
                   encoder: JSONParameterEncoder.default
        ).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let jsonData = try JSONDecoder().decode(Activities.self, from: data)
                    success(jsonData)
                } catch (let error) {
                    failure(error)
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func getWidgetActivities(success: @escaping ([Activity]) -> Void, failure: @escaping (Error) -> Void) {
        AF.request(Constants.baseUrl.appending("/activity/getWidgetActivities") as URLConvertible,
                     method: .post,
                     parameters: ["sessionToken": SessionManager.shared.getToken()],
                     encoder: JSONParameterEncoder.default
        ).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    print("hehe")
                    let jsonData = try JSONDecoder().decode([Activity].self, from: data)
                    success(jsonData)
                } catch (let error) {
                    failure(error)
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func insertActivities(activityData data: String, success: @escaping (Bool) -> Void, failure: @escaping (Error) -> Void) {
        AF.request(Constants.baseUrl.appending("/activity/insert") as URLConvertible,
                   method: .post,
                   parameters: ["activityData": data, "sessionToken": SessionManager.shared.getToken()],
                   encoder: JSONParameterEncoder.default
        ).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    success(true)
                } catch (let error) {
                    failure(error)
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
}
