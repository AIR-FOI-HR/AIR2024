//
//  RegistrationViewController.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 24.11.2020..
//

import UIKit

class RegistrationViewController: UIViewController {
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registerButtonClick(_ sender: UIButton) {
        let url = URL(string: "http://localhost:3000/registration")
        if let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text , let repeatPassword = repeatPasswordTextField.text {
            let json: [String: String] = ["name": name, "email": email, "password": password, "repeatPassword": repeatPassword]
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            
            var request =  URLRequest(url: url!)
            
            request.httpMethod = "POST"
            request.httpBody = jsonData!
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: getResponse(data:response:error:))
            
            task.resume()
        }
    }
    
    func getResponse(data: Data?, response: URLResponse?, error: Error?) {
        if let sData = data {
            if let jsonData = try? JSONSerialization.jsonObject(with: sData) as? [String: String] {
                print(jsonData["msg"])
            } else {
                print("No json object")
            }
        }
    }
}
