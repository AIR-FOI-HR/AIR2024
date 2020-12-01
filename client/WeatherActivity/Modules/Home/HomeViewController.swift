//
//  HomeViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 23.11.2020..
//

import UIKit
import KeychainSwift

final class HomeViewController: UIViewController {
    
    let keychain = KeychainSwift()
    @IBAction func backSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        keychain.delete("sessionToken")
        self.performSegue(withIdentifier: "HomeToLogin", sender: self)
    }
}
