//
//  UserService.swift
//  WeatherActivity
//
//  Created by Infinum on 21.01.2021..
//

import Foundation
import Alamofire

class UserService {
    func getUserProfileData(success: @escaping (User) -> Void, failure: @escaping (Error) -> Void) {
        AF.request(Constants.baseUrl.appending("/user/profile") as URLConvertible,
                     method: .post,
                     parameters: ["sessionToken": SessionManager.shared.getToken()],
                     encoder: JSONParameterEncoder.default
        ).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let jsonData = try JSONDecoder().decode(User.self, from: data)
                    success(jsonData)
                } catch (let error) {
                    failure(error)
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func updateUserProfileData(userData data: UserUpdate, success: @escaping (Bool) -> Void, failure: @escaping (Error) -> Void) {
        AF.request(Constants.baseUrl.appending("/user/profile/update") as URLConvertible,
                   method: .post,
                   parameters: data,
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
}

