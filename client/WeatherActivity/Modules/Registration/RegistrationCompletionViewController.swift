//
//  RegistrationCompletionViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 28.11.2020..
//

import UIKit

final class RegistrationCompletionViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    let alerter = Alerter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    var selectedAvatar = 0
    @IBAction func avatarPresed(_ sender: UIButton) {
        if(selectedAvatar != 0){
            let currentAvatar = self.view.viewWithTag(sender.tag)
            sender.selectedButtonAvatar(currentAvatar as! UIButton)
            
            let previousAvatar = self.view.viewWithTag(selectedAvatar)
            sender.deselectedButtonAvatar(previousAvatar as! UIButton)
            
            selectedAvatar = sender.tag
        } else {
            let currentAvatar = self.view.viewWithTag(sender.tag)
            sender.selectedButtonAvatar(currentAvatar as! UIButton)
            
            selectedAvatar = sender.tag
        }
    }
    
    @IBAction func finishButtonClicked(_ sender: UIButton) {
        guard let username = usernameTextField.text else { return }
        RegistrationUser.registrationUser.username = username
        RegistrationUser.registrationUser.avatar = selectedAvatar
        RegistrationService().register(userData: RegistrationUser.registrationUser, success: { registrationResponse in
            debugPrint(registrationResponse)
            if(registrationResponse.msg == "Error") {
                return
            }
            self.performSegue(withIdentifier: "toHome", sender: self)
        }, failure: {error in
            debugPrint(error)
            self.alerter.setAlerterData(title: "Oops!", message: "Error occured in registration process!")
            self.present(self.alerter.alerter, animated: true, completion: nil)
            return
        })
    }
    
    @IBAction func registrationCompletionTextFieldDidBeginEditing(_ sender: UITextField) {
        sender.updateTextAppearanceOnFieldDidBeginEditing(sender)
    }
    
    @IBAction func registrationCompletionTextFieldDidEndEditing(_ sender: UITextField) {
        sender.updateTextAppearanceOnFieldDidEndEditing(sender)
    }
}
