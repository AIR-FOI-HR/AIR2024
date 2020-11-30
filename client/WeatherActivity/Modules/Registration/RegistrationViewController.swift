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
        let alerter = Alerter()
        alerter.addAction(title: "Ok")
        guard let email = emailTextField.text, let password = passwordTextField.text , let firstName = firstNameTextField.text, let lastName = lastNameTextField.text,
        let repeatedPassword = repeatPasswordTextField.text else {
            alerter.setAlerterData(title: "Oops", message: "There was a problem with getting your input values")
            present(alerter.alerter, animated: true, completion: nil)
            return
        }
        
        let registrationValidator = RegistrationValidator(firstName: firstName, lastName: lastName, email: email, password: password, repeatedPassword: repeatedPassword)
        if(registrationValidator.emptyFieldExist()){
            alerter.setAlerterData(title: "Error", message: "One or more fields are empty!")
            present(alerter.alerter, animated: true, completion: nil)
            return
        }
        if(!registrationValidator.isValidEmail()){
            alerter.setAlerterData(title: "Error", message: "You entered invalid e-mail format!")
            present(alerter.alerter, animated: true, completion: nil)
            return
        }
        if(!registrationValidator.isValidRepeatedPassword()){
            alerter.setAlerterData(title: "Error", message: "Your passwords don't match!")
            present(alerter.alerter, animated: true, completion: nil)
            return
        }
        if(!registrationValidator.isValidPasswordLength()){
            alerter.setAlerterData(title: "Error", message: "Password must be at least 6 characters long!")
            present(alerter.alerter, animated: true, completion: nil)
            return
        }
        let newUser = User(email: email, username: "def", password: password, firstName: firstName, lastName: lastName, deviceToken: "", avatar: "av1")
        RegistrationService().register(userData: newUser, success: { registrationResponse in
            debugPrint(registrationResponse)
        }, failure: {error in
            debugPrint(error)
            alerter.setAlerterData(title: "Oops!", message: "Error occured in registration process!")
            self.present(alerter.alerter, animated: true, completion: nil)
            return
        })
        self.performSegue(withIdentifier: "toRegisterCompletion", sender: self)
    }
    
    @IBAction func registrationTextFieldDidBeginEditing(_ sender: UITextField) {
        sender.updateTextAppearanceOnFieldDidBeginEditing(sender)
    }
    
    @IBAction func registrationTextFieldDidEndEditing(_ sender: UITextField) {
        sender.updateTextAppearanceOnFieldDidEndEditing(sender)
    }
    
}
