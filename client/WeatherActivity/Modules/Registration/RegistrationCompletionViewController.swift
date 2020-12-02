//
//  RegistrationCompletionViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 28.11.2020..
//

import UIKit

final class RegistrationCompletionViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    // MARK: Properties
    
    let alerter = Alerter()
    let registrationService = RegistrationService()
    var firstStepData: FirstStepRegistrationData?
    var secondStepData: SecondStepRegistrationData?
    var selectedAvatar = 0
    
    // MARK: IBActions
    
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
            
            selectedAvatar = Int(sender.tag)
        }
    }
    
    @IBAction func finishButtonClicked(_ sender: UIButton) {
        guard let username = usernameTextField.text else { return }
        self.secondStepData = SecondStepRegistrationData(username: username, avatarId: selectedAvatar)
        let registrationData = RegistrationData(first: firstStepData, second: secondStepData)
        let registrationUser = RegistrationUser(firstName: registrationData.first!.firstName, lastName: registrationData.first!.lastName, email: registrationData.first!.email, password: registrationData.first!.password, username: registrationData.second!.username, avatarId: registrationData.second!.avatarId)
        
        registrationService.register(userData: registrationUser, success: { registrationResponse in
            if(registrationResponse.msg == "Error") {
                self.alerter.setAlerterData(title: "Oops!", message: "Error occured in registration process!")
                self.alerter.addAction(title: "Back")
                self.present(self.alerter.alerter, animated: true, completion: nil)
                return
            }
            if registrationResponse.token != "" {
                SessionManager.shared.saveToken(registrationResponse.token!)
            }
            self.performSegue(withIdentifier: "CompletionToHome", sender: self)
        }, failure: {error in
            debugPrint(error)
            self.alerter.setAlerterData(title: "Oops!", message: "Error occured in registration process!")
            self.alerter.addAction(title: "Back")
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
