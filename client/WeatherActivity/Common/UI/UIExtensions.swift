//
//  UIExtensions.swift
//  WeatherActivity
//
//  Created by Infinum on 26.11.2020..
//

import UIKit
    
// MARK: Text field start/stop editing
extension UITextField: UITextFieldDelegate {
    public func updateTextAppearanceOnFieldDidBeginEditing(_ textFieldEditing: UITextField) {
        textFieldEditing.layer.borderColor = UIColor(red:115/255, green:204/255, blue:255/255, alpha: 1).cgColor
        textFieldEditing.layer.borderWidth = 1.0
        textFieldEditing.layer.cornerRadius = 5.0
        textFieldEditing.layer.masksToBounds = false;
        textFieldEditing.tintColor = .some(UIColor(red:30/255, green:53/255, blue:65/255, alpha: 1))
    }
    
    public func updateTextAppearanceOnFieldDidEndEditing(_ textFieldEditingEnd: UITextField) {
        textFieldEditingEnd.layer.borderColor = UIColor.lightGray.cgColor
        textFieldEditingEnd.layer.borderWidth = 0
    }
}

// MARK: Text field on click next
extension UIViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}

// MARK: Dismiss keyboard on tap
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
