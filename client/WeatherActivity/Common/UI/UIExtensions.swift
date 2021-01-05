//
//  UIExtensions.swift
//  WeatherActivity
//
//  Created by Infinum on 26.11.2020..
//

import UIKit

// MARK: - Text field handling

extension UIViewController: UITextFieldDelegate {

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
