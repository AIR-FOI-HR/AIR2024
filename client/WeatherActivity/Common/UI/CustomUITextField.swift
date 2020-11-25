//
//  CustomUITextField.swift
//  WeatherActivity
//
//  Created by Infinum on 23.11.2020..
//

import UIKit

class CustomUITextField: UITextField {

    override func layoutSubviews() {
        super.layoutSubviews()
        borderStyle = .none
        layer.cornerRadius = 5
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowRadius = 2
        layer.masksToBounds = false
        layer.shadowOpacity = 0.2
        // set backgroundColor in order to cover the shadow inside the bounds
        layer.backgroundColor = UIColor.white.cgColor
    }
}

