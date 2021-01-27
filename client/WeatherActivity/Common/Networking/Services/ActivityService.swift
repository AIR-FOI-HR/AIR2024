//
//  ActivityService.swift
//  WeatherActivity
//
//  Created by Infinum on 06.12.2020..
//

import Foundation
import Alamofire

class ActivityService {
    func getActivities(for purpose: String, token sessionToken: String, success: @escaping ([Activities]) -> Void, failure: @escaping (Error) -> Void) {
        AF.request(Constants.baseUrl.appending("/activity") as URLConvertible,
                   method: .post,
                   parameters: ["sessionToken": sessionToken, "purpose": purpose],
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
    
    func insertActivities(activityData data: String, success: @escaping (Bool) -> Void, failure: @escaping (Error) -> Void) {
        AF.request(Constants.baseUrl.appending("/activity/insert") as URLConvertible,
                   method: .post,
                   parameters: ["activityData": data, "sessionToken": SessionManager.shared.getStringFromKeychain(key: .sessionToken)],
                   encoder: JSONParameterEncoder.default
        ).responseData { response in
            switch response.result {
            case .success(let data):
                guard let response = String(bytes: data, encoding: .utf8), let res = Bool(response) else {
                    return
                }
                success(res)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func updateActivity(activity id: Int, activityData data: String, success: @escaping (Bool) -> Void, failure: @escaping (Error) -> Void) {
        AF.request(Constants.baseUrl.appending("/activity/update/\(id)") as URLConvertible,
                   method: .post,
                   parameters: ["activityData": data, "sessionToken": SessionManager.shared.getStringFromKeychain(key: .sessionToken)],
                   encoder: JSONParameterEncoder.default
        ).responseData { response in
            switch response.result {
            case .success(let data):
                guard let response = String(bytes: data, encoding: .utf8), let res = Bool(response) else {
                    return
                }
                success(res)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func deleteActivities(activity id: Int, success: @escaping (Bool) -> Void, failure: @escaping (Error) -> Void) {
        AF.request(Constants.baseUrl.appending("/activity/delete/\(id)") as URLConvertible,
                   method: .post,
                   parameters: ["sessionToken": SessionManager.shared.getStringFromKeychain(key: .sessionToken)],
                   encoder: JSONParameterEncoder.default
        ).responseData { response in
            switch response.result {
            case .success(let data):
                guard let response = String(bytes: data, encoding: .utf8), let res = Bool(response) else {
                    return
                }
                success(res)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func getWidgetActivities(success: @escaping ([Activity]) -> Void, failure: @escaping (Error) -> Void) {
        AF.request(Constants.baseUrl.appending("/activity/getWidgetActivities") as URLConvertible,
                   method: .post,
                   parameters: ["sessionToken": SessionManager.shared.getStringFromKeychain(key: .sessionToken)],
                   encoder: JSONParameterEncoder.default
        ).responseData { response in
            switch response.result {
            case .success(let data):
                do {
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
    
    func getWidgetActivityDetails(activity id: Int, success: @escaping (Activities) -> Void, failure: @escaping (Error) -> Void) {
        AF.request(Constants.baseUrl.appending("/activity/widgetActivityDetails/\(id)") as URLConvertible,
                   method: .post,
                   parameters: ["sessionToken": SessionManager.shared.getStringFromKeychain(key: .sessionToken)],
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
}
