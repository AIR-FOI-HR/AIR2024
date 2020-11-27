//
//  RegistrationViewController.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 24.11.2020..
//

import UIKit

final class RegistrationViewController: UIViewController {
    
    @IBOutlet weak private var firstNameTextField: UITextField!
    @IBOutlet weak private var lastNameTextField: UITextField!
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    @IBOutlet weak private var repeatPasswordTextField: UITextField!
    
    @IBAction func registerButtonClick(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text , let firstName = firstNameTextField.text, let lastName = lastNameTextField.text {
            let newUser = User(email: email, username: "def", password: password, firstName: firstName, lastName: lastName, deviceToken: "", avatar: "av1")
            RegistrationService().registrateNewUser(userData: newUser, onSuccess: { registrationResponse in
                // User registration finished successfully
                debugPrint(registrationResponse)
            }, onFailure: {error in
                // Error occured in registration process
                debugPrint(error)
                self.showAlert()
            })
        }
    }
    
    @IBAction func registrationTextFieldDidBeginEditing(_ sender: UITextField) {
        sender.textFieldDidBeginEditing(sender)
    }
    
    @IBAction func registrationTextFieldDidEndEditing(_ sender: UITextField) {
        sender.textFieldDidEndEditing(sender)
    }
}

private extension RegistrationViewController {
    func showAlert() {
        let popupAlert = UIAlertController(title: "Oops!", message: "Something went wrong!", preferredStyle: UIAlertController.Style.alert)
        popupAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in
            popupAlert.dismiss(animated: true, completion: nil)
        }))
        self.present(popupAlert, animated: true, completion: nil)
    }
}
