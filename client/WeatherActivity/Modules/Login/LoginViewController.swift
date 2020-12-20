//
//  ViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 16.11.2020..
//

import UIKit

enum LoginNavigation: String {
    case home = "toHome"
    case registration = "toRegistration"
}

final class LoginViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    
    // MARK: Properties
    
    let textFieldAppearance = TextFieldAppearance()
    let loginService = LoginService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.text = UserDefaultsManager.shared.getUserDefaultString(key: .lastEnteredEmail)
    }
    
    // MARK: IBActions
    
    @IBAction func loginButtonClick(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            presentAlert(title: "Oops!", message: "There was a problem with getting your input values")
            return
        }
        let credentials = LoginCredentials(email: email, password: password)
        loginService.login(with: credentials, success: { apiResponse in
            SessionManager.shared.saveToken(apiResponse.sessionToken)
            if(!apiResponse.sessionToken.isEmpty) {
                UserDefaultsManager.shared.saveUserDefault(value: email, key: .lastEnteredEmail)
                self.navigate(to: .home)
            }
            else{
                self.presentAlert(title: "Oops!", message: "You entered wrong credentials")
            }
        }, failure: { error in
            self.presentAlert(title: "Oops!", message: "You entered wrong credentials")
        })
    }
    
    @IBAction func loginTextFieldDidBeginEditing(_ sender: UITextField) {
        textFieldAppearance.updateTextAppearanceOnFieldDidBeginEditing(sender)
    }
    
    @IBAction func loginTextFieldDidEndEditing(_ sender: UITextField) {
        textFieldAppearance.updateTextAppearanceOnFieldDidEndEditing(sender)
    }
}

// MARK: Navigation

private extension LoginViewController {
    func navigate(to path: LoginNavigation) {
        performSegue(withIdentifier: path.rawValue, sender: self)
    }
}
