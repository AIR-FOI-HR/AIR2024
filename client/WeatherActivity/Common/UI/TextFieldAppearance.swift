//
//  TextFieldAppearance.swift
//  WeatherActivity
//
//  Created by Infinum on 17.12.2020..
//

import UIKit
    
// MARK: - TextFieldAppearance class

class TextFieldAppearance: UITextField {
    
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
