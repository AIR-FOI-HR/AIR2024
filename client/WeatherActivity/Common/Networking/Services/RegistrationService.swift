//
//  RegistrationService.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 27.11.2020..
//

import Foundation
import Alamofire

class RegistrationService {
    
    func registrateNewUser(userData user: User, onSuccess: @escaping (registrationResponse)->Void, onFailure: @escaping (Error)->Void) {
        AF.request(Constants.baseUrl + "/registration",
           method: .post,
           parameters: user,
           encoder: JSONParameterEncoder.default).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let jsonData = try JSONDecoder().decode(registrationResponse.self, from: data)
                    onSuccess(jsonData)
                } catch (let error){
                    onFailure(error)
                }
            case .failure(let error):
                onFailure(error)
            }
        }
    }
}

struct registrationResponse: Decodable {
    let success: Bool
    let reason: String?
}

