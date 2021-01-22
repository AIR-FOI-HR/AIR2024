//
//  RegistrationCheck.swift
//  WeatherActivity
//
//  Created by Infinum on 29.11.2020..
//

import Foundation

protocol RegistrationProtocol {
    var firstName: String { get }
    var lastName: String { get }
    var email: String { get }
    var password: String { get }
    var repeatedPassword: String { get }
    
    func emptyFieldExist() -> Bool
    func isValidEmail() -> Bool
    func isValidRepeatedPassword() -> Bool
    func isValidPasswordLength() -> Bool
    func customValidation() -> (Bool, String)?
    
}

class RegistrationValidator: RegistrationProtocol {
    
    // MARK: Properties
    
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

    // MARK: Validate functions
    
    func emptyFieldExist() -> Bool{
        return firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty || repeatedPassword.isEmpty
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailCheck = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailCheck.evaluate(with: self.email)
    }

    func isValidRepeatedPassword() -> Bool {
        return self.password == repeatedPassword
    }

    func isValidPasswordLength() -> Bool{
        return self.password.count >= 6
    }
    
    func customValidation() -> (Bool, String)? {
        return nil
    }
}

class CustomRegistrationValidator: RegistrationProtocol {
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

