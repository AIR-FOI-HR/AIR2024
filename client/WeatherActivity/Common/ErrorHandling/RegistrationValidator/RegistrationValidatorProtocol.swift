//
//  RegistrationValidatorProtocol.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 27.01.2021..
//

import Foundation

protocol RegistrationRegistrationProtocol {
    
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
