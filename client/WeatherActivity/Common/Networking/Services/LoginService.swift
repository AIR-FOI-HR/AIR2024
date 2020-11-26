//
//  LoginServices.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 25.11.2020..
//

import Foundation
import Alamofire

class LoginService {
    
    func checkCredentials(userEmail email: String, userPassword pw: String, onSucces: @escaping (apiResponse) -> Void, onFailure: @escaping (Error) -> Void) {
            let login = Login(userEmail: email, userPassword: pw)
            AF.request(Constants.baseUrl + "/login",
               method: .post,
               parameters: login,
               encoder: JSONParameterEncoder.default).responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let jsonData = try JSONDecoder().decode(apiResponse.self, from: data)
                        onSucces(jsonData)
                    } catch (let error){
                        onFailure(error)
                    }
                case .failure(let error):
                    onFailure(error)
                }
            }
        }
}

struct Login: Codable {
    let userEmail: String
    let userPassword: String
}

struct apiResponse: Decodable {
    let logged: Bool?
    let deviceToken: String?
}



