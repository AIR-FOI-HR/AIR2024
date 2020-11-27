//
//  RegistrationService.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 27.11.2020..
//

import Foundation
import Alamofire

class RegistrationService {
    
    func register(userData user: User, success: @escaping (registrationResponse)->Void, failure: @escaping (Error)->Void) {
        let url = Constants.baseUrl
        AF.request(url.appending("/registration") as URLConvertible,
                   method: .post,
                   parameters: user,
                   encoder: JSONParameterEncoder.default).responseData { response in
                    switch response.result {
                    case .success(let data):
                        do {
                            let jsonData = try JSONDecoder().decode(registrationResponse.self, from: data)
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

struct registrationResponse: Decodable {
    let success: Bool
    let reason: String?
}

