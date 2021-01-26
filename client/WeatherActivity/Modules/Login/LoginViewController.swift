//
//  ViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 16.11.2020..
//

import UIKit
import WidgetKit

enum LoginNavigation: String {
    case home = "toHome"
    case registration = "toRegistration"
    case tabBar = "toTabBar"
}

final class LoginViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    @IBOutlet weak private var registerButton: UIButton!
    
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
            if(!apiResponse.sessionToken.isEmpty) {
                UserDefaultsManager.shared.saveUserDefault(value: email, key: .lastEnteredEmail)
                UserDefaultsManager.shared.saveUserDefault(value: apiResponse.userName, key: .userName)
                UserDefaultsManager.shared.saveUserDefault(value: apiResponse.userAvatar, key: .userAvatar)
                SessionManager.shared.saveToken(apiResponse.sessionToken)
                WidgetCenter.shared.reloadAllTimelines()
                
                self.navigate(to: .tabBar)
            }
            else {
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
    
    @IBAction func registerButtonClick(_ sender: UIButton) {
        navigate(to: .registration)
    }
}

// MARK: Navigation

private extension LoginViewController {
    func navigate(to path: LoginNavigation) {
        performSegue(withIdentifier: path.rawValue, sender: self)
    }
}
