//
//  UIButton+Appearance.swift
//  WeatherActivity
//
//  Created by Infinum on 17.12.2020..
//

import UIKit

//MARK: - Button appearance

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
