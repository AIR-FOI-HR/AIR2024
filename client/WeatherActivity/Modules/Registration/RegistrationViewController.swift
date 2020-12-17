//
//  RegistrationViewController.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 24.11.2020..
//
import UIKit

enum AlertMessages: String {
    case alertTitle = "Oops!"
    case inputValuesError = "There was a problem with getting your input values"
    case emptyFieldsError = "One or more fields are empty!"
    case invalidEmailError = "You entered invalid e-mail format!"
    case emailAlreadyExists = "Email is already in use!"
    case passwordMatchError = "Your passwords don't match!"
    case passwordLengthError = "Password must be at least 6 characters long!"
}

final class RegistrationViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak private var firstNameTextField: UITextField!
    @IBOutlet weak private var lastNameTextField: UITextField!
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    @IBOutlet weak private var repeatPasswordTextField: UITextField!
    
    // MARK: Properties
    
    let textFieldAppearance = TextFieldAppearance()
    var firstStepData: FirstStepRegistrationData?
    let registrationService = RegistrationService()
    
    // MARK: IBActions
    
    @IBAction func registerButtonClick(_ sender: UIButton) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text , let firstName = firstNameTextField.text, let lastName = lastNameTextField.text,
              let repeatedPassword = repeatPasswordTextField.text else {
            presentAlert(title: AlertMessages.alertTitle.rawValue, message: AlertMessages.inputValuesError.rawValue)
            return
        }
        
        let registrationValidator = RegistrationValidator(firstName: firstName, lastName: lastName, email: email, password: password, repeatedPassword: repeatedPassword)
        
        if(checkAllValidators(registrationValidator: registrationValidator) == false) {
            return
        }
        
        registrationService.checkEmail(userEmail: email) { (res) in
            if res.msg == "Available" {
                self.firstStepData = FirstStepRegistrationData(firstName: firstName, lastName: lastName, email: email, password: password)
                self.navigate(to: .registrationCompletion)
            } else {
                self.presentAlert(title: AlertMessages.alertTitle.rawValue, message: AlertMessages.emailAlreadyExists.rawValue)
                return
            }
            
        } failure: { (error) in
            #warning("Handle the error")
        }
    }
    
    @IBAction func registrationTextFieldDidBeginEditing(_ sender: UITextField) {
        textFieldAppearance.updateTextAppearanceOnFieldDidBeginEditing(sender)
    }
    
    @IBAction func registrationTextFieldDidEndEditing(_ sender: UITextField) {
        textFieldAppearance.updateTextAppearanceOnFieldDidEndEditing(sender)
    }
    
    
    @IBAction func backToLogin(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: Segue

extension RegistrationViewController {
    internal override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is RegistrationCompletionViewController == true {
            let registrationVC = segue.destination as! RegistrationCompletionViewController
            guard let data = self.firstStepData else {
                return
            }
            registrationVC.firstStepData = data
        }
    }
}

// MARK: Navigation

private extension RegistrationViewController {
    func navigate(to navigation: Navigation) {
        performSegue(withIdentifier: navigation.rawValue, sender: self)
    }
}

// MARK: Validation methods

private extension RegistrationViewController {
    
    func checkAllValidators(registrationValidator: RegistrationValidator) -> Bool {
        if (checkForEmptyFields(registrationValidator: registrationValidator) == false) {
            return false
        }
        else if (isEmailValid(registrationValidator: registrationValidator) == false) {
            return false
        }
        else if (isRepeatedPasswordValid(registrationValidator: registrationValidator) == false) {
            return false
        }
        else if (isPasswordLengthValid(registrationValidator: registrationValidator) == false) {
            return false
        }
        return true
    }
    
    func checkForEmptyFields(registrationValidator: RegistrationValidator) -> Bool {
        if(registrationValidator.emptyFieldExist()){
            presentAlert(title: AlertMessages.alertTitle.rawValue, message: AlertMessages.emptyFieldsError.rawValue)
            return false
        }
        return true
    }
    
    func isEmailValid(registrationValidator: RegistrationValidator) -> Bool {
        if(!registrationValidator.isValidEmail()){
            presentAlert(title: AlertMessages.alertTitle.rawValue, message: AlertMessages.invalidEmailError.rawValue)
            return false
        }
        return true
    }
    
    func isRepeatedPasswordValid(registrationValidator: RegistrationValidator) -> Bool {
        if(!registrationValidator.isValidRepeatedPassword()){
            presentAlert(title: AlertMessages.alertTitle.rawValue, message: AlertMessages.passwordMatchError.rawValue)
            return false
        }
        return true
    }
    
    func isPasswordLengthValid(registrationValidator: RegistrationValidator) -> Bool {
        if(!registrationValidator.isValidPasswordLength()){
            presentAlert(title: AlertMessages.alertTitle.rawValue, message: AlertMessages.passwordLengthError.rawValue)
            return false
        }
        return true
    }
    
}
