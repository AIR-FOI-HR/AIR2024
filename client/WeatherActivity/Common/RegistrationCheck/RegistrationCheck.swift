//
//  RegistrationCheck.swift
//  WeatherActivity
//
//  Created by Infinum on 29.11.2020..
//

import Foundation

func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    let emailCheck = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailCheck.evaluate(with: email)
}
