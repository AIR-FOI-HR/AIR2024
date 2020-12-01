//
//  UIExtensions.swift
//  WeatherActivity
//
//  Created by Infinum on 26.11.2020..
//

import UIKit
    
// MARK: Text field start/stop editing

extension UITextField: UITextFieldDelegate {
    
    func updateTextAppearanceOnFieldDidBeginEditing(_ textFieldEditing: UITextField) {
        textFieldEditing.layer.borderColor = UIColor(red:115/255, green:204/255, blue:255/255, alpha: 1).cgColor
        textFieldEditing.layer.borderWidth = 1.0
        textFieldEditing.layer.cornerRadius = 5.0
        textFieldEditing.layer.masksToBounds = false;
        textFieldEditing.tintColor = .some(UIColor(red:30/255, green:53/255, blue:65/255, alpha: 1))
    }
    
    func updateTextAppearanceOnFieldDidEndEditing(_ textFieldEditingEnd: UITextField) {
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

extension UIButton {
    func selectedButtonAvatar(_ button: UIButton) {
        button.layer.cornerRadius = 5.0
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red:115/255, green:204/255, blue:255/255, alpha: 1).cgColor
        button.layer.shadowColor = UIColor(red:115/255, green:204/255, blue:255/255, alpha: 1).cgColor
        button.layer.shadowOpacity = 0.5
    }
    
    func deselectedButtonAvatar(_ button: UIButton) {
        button.layer.cornerRadius = 0
        button.layer.borderWidth = 0
        button.layer.borderColor = UIColor(red:255/255, green:255/255, blue:255/255, alpha: 1).cgColor
        button.layer.shadowColor = UIColor(red:255/255, green:255/255, blue:255/255, alpha: 1).cgColor
        button.layer.shadowOpacity = 0
    }
}
