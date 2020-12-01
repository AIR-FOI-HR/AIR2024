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
    
    enum AlertMessages: String {
        case inputValuesError = "There was a problem with getting your input values"
        case emptyFieldsError = "One or more fields are empty!"
        case invalidEmailError = "You entered invalid e-mail format!"
        case passwordMatchError = "Your passwords don't match!"
        case passwordLengthError = "Password must be at least 6 characters long!"
    }
    
    @IBAction func registerButtonClick(_ sender: UIButton) {
        let alerter = Alerter()
        let alertActionText = "Ok"
        let alertTitle = "Oops!"
        alerter.addAction(title: alertActionText)
        
        guard let email = emailTextField.text, let password = passwordTextField.text , let firstName = firstNameTextField.text, let lastName = lastNameTextField.text,
        let repeatedPassword = repeatPasswordTextField.text else {
            alerter.setAlerterData(title: alertTitle, message: AlertMessages.inputValuesError.rawValue)
            present(alerter.alerter, animated: true, completion: nil)
            return
        }
        
        let registrationValidator = RegistrationValidator(firstName: firstName, lastName: lastName, email: email, password: password, repeatedPassword: repeatedPassword)
        if(registrationValidator.emptyFieldExist()){
            alerter.setAlerterData(title: alertTitle, message: AlertMessages.emptyFieldsError.rawValue)
            present(alerter.alerter, animated: true, completion: nil)
            return
        }
        if(!registrationValidator.isValidEmail()){
            alerter.setAlerterData(title: alertTitle, message: AlertMessages.invalidEmailError.rawValue)
            present(alerter.alerter, animated: true, completion: nil)
            return
        }
        if(!registrationValidator.isValidRepeatedPassword()){
            alerter.setAlerterData(title: alertTitle, message: AlertMessages.passwordMatchError.rawValue)
            present(alerter.alerter, animated: true, completion: nil)
            return
        }
        if(!registrationValidator.isValidPasswordLength()){
            alerter.setAlerterData(title: alertTitle, message: AlertMessages.passwordLengthError.rawValue)
            present(alerter.alerter, animated: true, completion: nil)
            return
        }
        
        RegistrationUser.registrationUser.email = email
        RegistrationUser.registrationUser.password = password
        RegistrationUser.registrationUser.firstName = firstName
        RegistrationUser.registrationUser.lastName = lastName
        
        self.performSegue(withIdentifier: "toRegisterCompletion", sender: self)
    }
    
    @IBAction func registrationTextFieldDidBeginEditing(_ sender: UITextField) {
        sender.updateTextAppearanceOnFieldDidBeginEditing(sender)
    }
    
    @IBAction func registrationTextFieldDidEndEditing(_ sender: UITextField) {
        sender.updateTextAppearanceOnFieldDidEndEditing(sender)
    }
    
}
