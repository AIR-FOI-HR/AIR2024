//
//  RegistrationCompletionViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 28.11.2020..
//

import UIKit

final class RegistrationCompletionViewController: UIViewController {

    @IBAction func registrationCompletionTextFieldDidBeginEditing(_ sender: UITextField) {
        sender.updateTextAppearanceOnFieldDidBeginEditing(sender)
    }
    
    @IBAction func registrationCompletionTextFieldDidEndEditing(_ sender: UITextField) {
        sender.updateTextAppearanceOnFieldDidEndEditing(sender)
    }
}
