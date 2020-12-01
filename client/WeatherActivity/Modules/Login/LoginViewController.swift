//
//  ViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 16.11.2020..
//

import UIKit

final class LoginViewController: UIViewController {

    // MARK: IBOutlets

    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!

    // MARK: Properties

    let loginService = LoginService()
    let secureStorage = SecureStorage()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let sessionToken = secureStorage.getToken(keyType: .sessionToken) {
            loginService.checkForToken(token: sessionToken, success: { checkResponse in
                self.navigate(to: .home)
            }, failure: { error in
                #warning("Return message to the user")
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
            self.secureStorage.saveToken(sessionToken: apiResponse.sessionToken, keyType: .sessionToken)
            if(!apiResponse.sessionToken.isEmpty) {
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

// MARK: Navigation

private extension LoginViewController {
    func navigate(to navigation: Navigation) {
        performSegue(withIdentifier: navigation.rawValue, sender: self)
    }
}
