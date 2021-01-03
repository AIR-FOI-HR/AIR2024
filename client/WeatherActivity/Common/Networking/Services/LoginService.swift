//
//  LoginServices.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 25.11.2020..
//

import Foundation
import Alamofire

class LoginService {
    
    func login(with credentials: LoginCredentials, success: @escaping (AuthResponse) -> Void, failure: @escaping (Error) -> Void) {
        AF.request(Constants.baseUrl.appending("/login") as URLConvertible,
                   method: .post,
                   parameters: credentials,
                   encoder: JSONParameterEncoder.default)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let jsonData = try JSONDecoder().decode(AuthResponse.self, from: data)
                        success(jsonData)
                    } catch (let error) {
                        failure(error)
                    }
                case .failure(let error):
                    failure(error)
                }
            }
    }
    
    func checkForToken(token sessionToken: String, success: @escaping (TokenCheckResponse) -> Void, failure: @escaping (Error) -> Void) {
        AF.request(Constants.baseUrl.appending("/login/tokenCheck") as URLConvertible,
                   method: .post,
                   parameters: ["sessionToken": sessionToken],
                   encoder: JSONParameterEncoder.default)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let jsonData = try JSONDecoder().decode(TokenCheckResponse.self, from: data)
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




