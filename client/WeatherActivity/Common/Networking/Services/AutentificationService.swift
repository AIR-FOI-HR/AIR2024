//
//  LoginServices.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 25.11.2020..
//

import Foundation
import Alamofire

struct Constants {
    // MARK: - Networking
    
    static let baseUrl = "http://localhost:3000"
}

class AutentificationService {
    
    func checkCredentials(userEmail email: String, userPassword pw: String, completitionHandler: @escaping (Result<apiResponse,Error>) -> Void) {
        let login = Login(userEmail: email, userPassword: pw)
        AF.request(Constants.baseUrl + "/login",
                   method: .post,
                   parameters: login,
                   encoder: JSONParameterEncoder.default).responseData { response in
                    switch response.result {
                    case .success(let data):
                        print(data)
                        do {
                            let jsonData = try JSONDecoder().decode(apiResponse.self, from: data)
                            completitionHandler(.success(jsonData))
                        } catch (let error){
                            completitionHandler(.failure(error))
                        }
                    case .failure(let error):
                        completitionHandler(.failure(error))
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



