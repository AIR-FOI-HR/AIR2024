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
        let url = Constants.baseUrl
        AF.request(url.appending("/login") as URLConvertible,
                   method: .post,
                   parameters: credentials,
                   encoder: JSONParameterEncoder.default).responseData { response in
                    switch response.result {
                    case .success(let data):
                        do {
                            let jsonData = try JSONDecoder().decode(AuthResponse.self, from: data)
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

struct LoginCredentials: Codable {
    let email: String
    let password: String
}

struct AuthResponse: Decodable {
    let logged: Bool
    let sessionToken: String
}



