//
//  RegistrationService.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 27.11.2020..
//

import Foundation
import Alamofire

class RegistrationService {
    
    func register(userData user: RegistrationUser, success: @escaping (AuthResponse)->Void, failure: @escaping (Error)->Void) {
        AF.request(Constants.baseUrl.appending("/registration") as URLConvertible,
                   method: .post,
                   parameters: user,
                   encoder: JSONParameterEncoder.default
        ).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let jsonData = try JSONDecoder().decode(AuthResponse.self, from: data)
                    print("jsondata: \(jsonData)")
                    success(jsonData)
                } catch (let error){
                    print("er: \(error)")
                    failure(error)
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func checkEmail(userEmail email: String, success: @escaping (EmailCheckResponse)->Void, failure: @escaping (Error)->Void) {
        AF.request(Constants.baseUrl.appending("/registration/mailcheck") as URLConvertible,
                   method: .post,
                   parameters: ["email":email],
                   encoder: JSONParameterEncoder.default,
                   headers: ["Content-Type": "application/json"]
        ).responseData { (res) in
            switch res.result {
            case .success(let data):
                do {
                    let jsonData = try JSONDecoder().decode(EmailCheckResponse.self, from: data)
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

