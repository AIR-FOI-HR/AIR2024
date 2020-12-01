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
        registrationUser = RegistrationUser(userEmail: email, userFirstName: firstName, userLastName: lastName, userPassword: password)
        
        self.performSegue(withIdentifier: "toRegisterCompletion", sender: self)
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
