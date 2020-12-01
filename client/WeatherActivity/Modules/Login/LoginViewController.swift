//
//  ViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 16.11.2020..
//

import UIKit
import KeychainSwift

enum LoginNavigation: String {
    case home = "toHome"
    case registration = "toRegistration"
}

final class LoginViewController: UIViewController {
    
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    
    let loginService = LoginService()
    let keychain = KeychainSwift()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //keychain.delete("sessionToken")
        if let sessionToken = keychain.get("sessionToken") {
            loginService.checkForToken(token: sessionToken, success: { checkResponse in
                checkResponse.token == true ? self.navigate(to: .home) : print(sessionToken)
            }, failure: { error in
                print("error \(error)")
            })
        }
    }
    
    @IBAction func loginButtonClick(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            let alerter = Alerter(title: "Oops!", message: "There was a problem with getting your input values")
            alerter.addAction(title: "Ok")
            present(alerter.alerter, animated: true, completion: nil)
            return
        }
        let credentials = LoginCredentials(email: email, password: password)
        loginService.login(with: credentials, success: { apiResponse in
            self.keychain.set(apiResponse.sessionToken, forKey: "sessionToken")
            if(apiResponse.logged){
                self.navigate(to: .home)
            }
            else{
                let alerter = Alerter(title: "Oops!", message: "You entered wrong credentials")
                alerter.addAction(title: "Ok")
                self.present(alerter.alerter, animated: true, completion: nil)
            }
        }, failure: { error in
            let alerter = Alerter(title: "Oops!", message: "You entered wrong credentials")
            alerter.addAction(title: "Ok")
            self.present(alerter.alerter, animated: true, completion: nil)
        })
    }
    
    // MARK: IBAction functions
    @IBAction func loginTextFieldDidBeginEditing(_ sender: UITextField) {
        sender.updateTextAppearanceOnFieldDidBeginEditing(sender)
    }
    
    @IBAction func loginTextFieldDidEndEditing(_ sender: UITextField) {
        sender.updateTextAppearanceOnFieldDidEndEditing(sender)
    }
}

private extension LoginViewController {
    func navigate(to navigation: LoginNavigation) {
        performSegue(withIdentifier: navigation.rawValue, sender: self)
    }
}
