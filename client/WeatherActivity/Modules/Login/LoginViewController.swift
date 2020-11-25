//
//  ViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 16.11.2020..
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func loginButtonClick(_ sender: UIButton) {
        let autentificationService = AutentificationService()
        if let email = emailTextField.text, let password = passwordTextField.text {
            autentificationService.loginAutentification(email: email, password: password, completitionHandler: { (msg) in
                if msg {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "toHome", sender: self)
                    }
                } else {
                    DispatchQueue.main.async {
                        let popupAlert = UIAlertController(title: "Oops!", message: "Wrong credentials", preferredStyle: UIAlertController.Style.alert)
                        popupAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in
                            popupAlert.dismiss(animated: true, completion: nil)
                        }))
                        self.present(popupAlert, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    @IBAction func emailTextFieldStart(_ sender: Any) {
        emailTextField.layer.borderColor = UIColor(red:115/255, green:204/255, blue:255/255, alpha: 1).cgColor
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.cornerRadius = 5.0
        emailTextField.layer.masksToBounds = false;
        emailTextField.tintColor = .some(UIColor(red:30/255, green:53/255, blue:65/255, alpha: 1))
    }
    
    @IBAction func emailTextFieldStop(_ sender: Any) {
        
        emailTextField.layer.borderColor = UIColor.lightGray.cgColor
        emailTextField.layer.borderWidth = 0
    }
    
    
    @IBAction func passTextFieldStart(_ sender: Any) {
        
        passwordTextField.layer.borderColor = UIColor(red:115/255, green:204/255, blue:255/255, alpha: 1).cgColor
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.cornerRadius = 5.0
        passwordTextField.layer.masksToBounds = false;
        passwordTextField.tintColor = .some(UIColor(red:30/255, green:53/255, blue:65/255, alpha: 1))
    }
    
    @IBAction func passTextFieldEnd(_ sender: Any) {
        passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        passwordTextField.layer.borderWidth = 0
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }
    
    
}


// Codable json object
