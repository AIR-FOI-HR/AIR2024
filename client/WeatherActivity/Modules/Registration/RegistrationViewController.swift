//
//  RegistrationViewController.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 24.11.2020..
//
import UIKit

final class RegistrationViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak private var firstNameTextField: UITextField!
    @IBOutlet weak private var lastNameTextField: UITextField!
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    @IBOutlet weak private var repeatPasswordTextField: UITextField!
    
    var registrationUser: RegistrationUser?
    enum AlertMessages: String {
        case inputValuesError = "There was a problem with getting your input values"
        case emptyFieldsError = "One or more fields are empty!"
        case invalidEmailError = "You entered invalid e-mail format!"
        case emailAlreadyExists = "Email is already in use!"
        case passwordMatchError = "Your passwords don't match!"
        case passwordLengthError = "Password must be at least 6 characters long!"
    }
    
    let alerter = Alerter()
    
    @IBAction func registerButtonClick(_ sender: UIButton) {
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
        RegistrationService().checkEmail(userEmail: email) { (res) in
            if res.msg == "Available" {
                self.registrationUser = RegistrationUser(userEmail: email, userFirstName: firstName, userLastName: lastName, userPassword: password)
                self.performSegue(withIdentifier: "toRegisterCompletion", sender: self)
            } else {
                self.alerter.setAlerterData(title: alertTitle, message: AlertMessages.emailAlreadyExists.rawValue)
                self.present(self.alerter.alerter, animated: true, completion: nil)
                return
            }
            
        } failure: { (error) in
            #warning("Handle the error")
        }

        
        
    }
    
    @IBAction func registrationTextFieldDidBeginEditing(_ sender: UITextField) {
        sender.updateTextAppearanceOnFieldDidBeginEditing(sender)
    }
    
    @IBAction func registrationTextFieldDidEndEditing(_ sender: UITextField) {
        sender.updateTextAppearanceOnFieldDidEndEditing(sender)
    }
    
}

// MARK: Segue
extension RegistrationViewController {
    internal override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is RegistrationCompletionViewController == true {
            let registrationVC = segue.destination as! RegistrationCompletionViewController
            registrationVC.registrationUser = registrationUser
        }
    }
}
