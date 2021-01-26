//
//  RegistrationViewController.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 24.11.2020..
//
import UIKit


enum RegisterNavigation: String {
    case registrationCompletion = "toRegisterCompletion"
}

final class RegistrationViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak private var firstNameTextField: UITextField!
    @IBOutlet weak private var lastNameTextField: UITextField!
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    @IBOutlet weak private var repeatPasswordTextField: UITextField!
    
    // MARK: Properties
    
    var userInformation: UserInformation?
    let textFieldAppearance = TextFieldAppearance()
    let registrationService = RegistrationService()
    
    // MARK: IBActions
    
    @IBAction func registerButtonClick(_ sender: UIButton) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text , let firstName = firstNameTextField.text, let lastName = lastNameTextField.text,
              let repeatedPassword = repeatPasswordTextField.text else {
            presentAlert(title: "Oops!", message: "There was a problem with getting your input values")
            return
        }
        
        let registrationValidator = RegistrationValidator(firstName: firstName, lastName: lastName, email: email, password: password, repeatedPassword: repeatedPassword)
        
        if(checkAllValidators(registrationValidator: registrationValidator) == false) {
            return
        }
        
        registrationService.checkEmail(userEmail: email) { (res) in
            if !res.exists {
                self.userInformation = UserInformation(firstName: firstName, lastName: lastName, email: email, password: password)
                self.navigate(to: .registrationCompletion)
            } else {
                self.presentAlert(title: "Oops!", message: "Email is already in use!")
                return
            }
            
        } failure: { (error) in
            self.presentAlert(title: "Oops!", message: "Something went wrong!")
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
            guard let data = self.userInformation else {
                return
            }
            registrationVC.userInformation = data
        }
    }
}

// MARK: Navigation

private extension RegistrationViewController {
    func navigate(to path: RegisterNavigation) {
        performSegue(withIdentifier: path.rawValue, sender: self)
    }
}

// MARK: Validation methods

private extension RegistrationViewController {
    
    func checkAllValidators(registrationValidator: RegistrationProtocol) -> Bool {
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
        } else if (customValidation(registrationValidator: registrationValidator) == false) {
            return false
        }
        return true
    }
    
    func checkForEmptyFields(registrationValidator: RegistrationProtocol) -> Bool {
        if(registrationValidator.emptyFieldExist()){
            presentAlert(title: "Oops!", message: "One or more fields are empty!")
            return false
        }
        return true
    }
    
    func isEmailValid(registrationValidator: RegistrationProtocol) -> Bool {
        if(!registrationValidator.isValidEmail()){
            presentAlert(title: "Oops!", message: "You entered invalid e-mail format!")
            return false
        }
        return true
    }
    
    func isRepeatedPasswordValid(registrationValidator: RegistrationProtocol) -> Bool {
        if(!registrationValidator.isValidRepeatedPassword()){
            presentAlert(title: "Oops!", message: "Your passwords don't match!")
            return false
        }
        return true
    }
    
    func isPasswordLengthValid(registrationValidator: RegistrationProtocol) -> Bool {
        if(!registrationValidator.isValidPasswordLength()){
            presentAlert(title: "Oops!", message: "Password must be at least 6 characters long!")
            return false
        }
        return true
    }
    
    func customValidation(registrationValidator: RegistrationProtocol) -> Bool {
        guard
            let validation = registrationValidator.customValidation()?.0,
            let msg = registrationValidator.customValidation()?.1
        else {
            return true
        }
        if(validation == false) {
            presentAlert(title: "Oops!", message: msg)
            return false
        }
        return true
    }
    
}
