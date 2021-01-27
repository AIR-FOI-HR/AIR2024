//
//  CustomRegistrationValidator.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 27.01.2021..
//

import Foundation

class CustomRegistrationValidator: RegistrationRegistrationProtocol {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    let repeatedPassword: String
    
    init(firstName: String, lastName: String, email: String, password: String, repeatedPassword: String){
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
        self.repeatedPassword = repeatedPassword
    }
    
    func emptyFieldExist() -> Bool {
        return firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty || repeatedPassword.isEmpty
    }
    
    func isValidEmail() -> Bool {
        return email.contains("@gmail.com")
    }
    
    func isValidRepeatedPassword() -> Bool {
        return self.password == repeatedPassword
    }
    
    func isValidPasswordLength() -> Bool {
        return self.password.count >= 8
    }
    
    func customValidation() -> (Bool, String)? {
        if(firstName.contains("#")) {
            return (false, "First name contains '#'")
        } else {
            return nil
        }
    }
}
