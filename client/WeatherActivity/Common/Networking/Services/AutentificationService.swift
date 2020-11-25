//
//  LoginServices.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 25.11.2020..
//

import Foundation

class AutentificationService {
    let url = URL(string: "http://localhost:3000/login")
    
    func loginAutentification(email: String, password: String, completitionHandler: @escaping (Bool) -> Void) {
        let json: [String: String] = ["email": email, "password": password]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request =  URLRequest(url: url!)
        
        request.httpMethod = "POST"
        request.httpBody = jsonData!
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        // alamofire - lib
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let sData = data, let jsonData = try? JSONSerialization.jsonObject(with: sData) as? [String: Bool], let msg = jsonData["logged"]  else {
                return
            }
            completitionHandler(msg)
        })
        
        task.resume()
    }
}
