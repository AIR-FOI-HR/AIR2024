//
//  RegistrationCompletionViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 28.11.2020..
//

import UIKit

final class RegistrationCompletionViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!

    var selectedAvatar = 1
    @IBAction func avatarPresed(_ sender: UIButton) {
        let currentAvatar = self.view.viewWithTag(sender.tag)
        sender.selectedButtonAvatar(currentAvatar as! UIButton)
        
        let previousAvatar = self.view.viewWithTag(selectedAvatar)
        sender.deselectedButtonAvatar(previousAvatar as! UIButton)
        
        selectedAvatar = sender.tag
    }

    @IBAction func finishButtonClicked(_ sender: UIButton) {
        guard let username = usernameTextField.text else { return }
        let databaseAvatar = "avatar" + String(selectedAvatar)
        print(databaseAvatar)
    }
    
    @IBAction func registrationCompletionTextFieldDidBeginEditing(_ sender: UITextField) {
        sender.updateTextAppearanceOnFieldDidBeginEditing(sender)
    }
    
    @IBAction func registrationCompletionTextFieldDidEndEditing(_ sender: UITextField) {
        sender.updateTextAppearanceOnFieldDidEndEditing(sender)
    }
}
