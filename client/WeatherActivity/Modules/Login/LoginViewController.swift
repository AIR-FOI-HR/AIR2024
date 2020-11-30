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
    
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    
    let loginService = LoginService()
    
    @IBAction func loginButtonClick(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            // Return message to the user
            return
        }
        let credentials = LoginCredentials(email: email, password: password)
        loginService.login(with: credentials, success: { apiResponse in
            apiResponse.logged == true ? self.navigate(to: .home) : self.showAlert()
        }, failure: { error in
            print("error \(error)")
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
    
    func showAlert() {
        let popupAlert = UIAlertController(title: "Oops!", message: "Wrong credentials", preferredStyle: UIAlertController.Style.alert)
        popupAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in
            popupAlert.dismiss(animated: true, completion: nil)
        }))
        self.present(popupAlert, animated: true, completion: nil)
    }
}
